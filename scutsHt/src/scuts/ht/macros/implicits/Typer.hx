
package scuts.ht.macros.implicits;

#if macro 

import haxe.ds.StringMap;
import haxe.macro.TypeTools;
import haxe.Serializer;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Serializer;
import haxe.Unserializer;
import scuts.ht.macros.implicits.Cache;

import haxe.macro.Type;
import scuts.ht.macros.implicits.Log;


using scuts.core.Options;
using scuts.core.Strings;

class Typer {

  static var optimizerEnabled = false;

  static var cache = new Cache();
  static var fastTypeCache = new Cache();

  static var nextTypeId = 0;


  static var eCache : StringMap<Option<Type>> = null;

  public static function typeFromCache (id:String):Option<Type> {
    var t = eCache.get(id);
    //var s = Serializer.run(t);
    //var r = Unserializer.run(s);
    return t;
  }

  public static function cacheExists (id:String) {
    return eCache.exists(id);    
  }

 



  public  static function typeof(x:Expr):Option<Type>
  {
    return try Some(Context.typeof(x)) catch (e:Dynamic) None;
  }


  public static function typeofOld(x:Expr):Option<Type>
  {
    return Profiler.profile(function () 
    {
      if (eCache == null) {
        eCache = new StringMap();
      }


      //var id = haxe.macro.ExprTools.toString(x) + "--" + Context.getPosInfos(Context.currentPos());

      //Log.logExpr(x);
      return if (false) // cacheExists(id)) 
      {
        Profiler.pushPop("from-cache");
        //typeFromCache(id);
        null;
      } 
      else 
      {
        if (optimizerEnabled) 
        {
          switch (x.expr) 
          {
            case EMeta(entry, _) if (entry.name.startsWith("fastTypeable")): 
              var id = entry.name;
              
              
              var r = fastTypeCache.get(id)();
              if (r.first) {
                Profiler.pushPop("first-expr-cache");
              } else {
                Profiler.pushPop("from-expr-cache");
              }
              return r.e;
            default:
          }
        }
        
        var r =  try Some(Context.typeof(x)) catch (e:Dynamic) None;
        //eCache.set(id, r);
        Profiler.pushPop("no-cache");
        r;
      }
    });
    
  }



  public static function makeFastTypeable(x:Expr):Expr 
  {
    return Profiler.profile(function () 
    {
      return if (optimizerEnabled) 
      {
        var id = "fastTypeable" + nextTypeId++;
        try 
        {
          var cache = null;
          var t = function () 
          {
            return if (cache == null) 
            {
              cache = Profiler.profile(typeof.bind(x), "no-cache");
              { e: cache, first: true}
            } 
            else {
              Profiler.pushPop("cache");
              { e: cache, first: false};
            }
          }
          fastTypeCache.set(id, t);
          
          { expr : EMeta({ name : id, params : [], pos : x.pos} , x), pos : x.pos };
        } catch (e:Dynamic) x;
      } 
      else x;
    });
  }


  /**
   * Checks if the expression e is typeable by the compiler.
   */
 
  public static function isTypeable (e:Expr) 
  {
    return Profiler.profile(function () 
      return Typer.typeof(e).isSome()
    );
  }
  
  /**
   * Checks if the type of expression e is compatible to the type of to.
   */
  

  public static function isCompatible (e:Expr, to:Expr) 
  {
    return Profiler.profile(function () 
    {
      var helper = Resolver.helper;
      return Typer.typeof(macro $helper.typeAsParam($to)($e)).isSome();
    });
  }




}

#end