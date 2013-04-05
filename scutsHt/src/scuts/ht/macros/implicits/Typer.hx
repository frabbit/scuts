
package scuts.ht.macros.implicits;

#if macro 

import haxe.macro.Context;
import haxe.macro.Expr;
import scuts.ht.macros.implicits.Cache;

import haxe.macro.Type;

using scuts.core.Strings;

class Typer {

  static var optimizerEnabled = false;

  static var cache = new Cache();
  static var fastTypeCache = new Cache();

  static var nextTypeId = 0;

  static var typings = 0;

  static var typeofCalls = {
    #if debug
    Context.onGenerate(function (t) {
      trace("typeofCalls:" + Std.string(typeofCalls));
    });
    #end
    0;
  }

  public static function typeof(x:Expr):Type 
  {
    typeofCalls++;
    if (optimizerEnabled) {
      switch (x.expr) {
        case EMeta(entry, _) if (entry.name.startsWith("fastTypeable")): 
          var id = entry.name;
          //trace("use fast type cache");
          return fastTypeCache.get(id);
        default:
      }
    }
    return Context.typeof(x);
    
    var sig = Context.signature(x);
    var r = if (!cache.exists(sig)) {

      cache.set(sig, Context.typeof(x));
    } else {
      //trace("type cache exists");
      cache.get(sig);
    }
    return r;

  }



  public static function tryFastTypeable(x:Expr):Expr 
  {
    
    if (optimizerEnabled) {
      var id = "fastTypeable" + nextTypeId++;
      return try {
        var t = typeof(x);
        fastTypeCache.set(id, t);
        { expr : EMeta({ name : id, params : [], pos : x.pos} , x), pos : x.pos };
      } catch (e:Dynamic) {
        x;
      }
    } else {
      return x;
    }
  }

  public static function typeAndSub(x:Expr):{type:Type, expr:Expr} {
    var t = typeof(x);
    var ct = Context.toComplexType(t);
    return { type : t, expr : { expr : ECheckType(x, ct), pos : x.pos} };

  }



}

#end