package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

//using scuts.Core;
import haxe.macro.Compiler;
import scuts.core.Arrays;
import scuts.core.Ints;
import scuts.core.Predicates;
import scuts.core.Strings;
import scuts.core.Log;
import scuts.core.Validation;
import scuts.CoreTypes;
import scuts.mcore.extensions.Types;
import scuts.Scuts;


using scuts.core.Arrays;
using scuts.core.Options;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.Stack;
import neko.FileSystem;
import neko.io.File;
using scuts.core.Ints;
using scuts.core.Dynamics;
using scuts.core.Options;
using scuts.core.Log;
using scuts.mcore.extensions.Types;
using scuts.core.Strings;
using scuts.core.Validations;
using scuts.core.Functions;
private typedef Ctx = haxe.macro.Context;

private typedef TypeCacheKey = { name:String, type:TypeKind, isPrivate:Bool };

enum TypeKind 
{
	TClass;
	TTypedef;
	TEnum;
  TInterface;
}
 
class Context 
{
  static var cacheEnabled:Bool = false;
  
  public static function setupCache ():Bool 
  {
    return if (!cacheEnabled) 
    {
      if (!FileSystem.exists(Constants.SCUTS_CACHE_FOLDER)) 
      {
        FileSystem.createDirectory(Constants.SCUTS_CACHE_FOLDER);
      }
      Compiler.addClassPath(Constants.SCUTS_CACHE_FOLDER + "/");
      cacheEnabled = true;
    } 
    else false;
  }
  public static function getCacheFolder ():String 
  {
    setupCache();
    return Constants.SCUTS_CACHE_FOLDER;
  }
  
  
  public static function getFunctionTypeParameters (type:Type, functionName:String):Array<Type>
  {
    function loop (type:Type, found:Array<Type>) 
    {
      function searchInParams (params:Array<Type>) 
      {
        return params.foldLeft(function (acc, cur) return loop(cur, acc), found);
      }
      
      function isFunctionTypeParameter (t:ClassType) 
      {
        var pack = t.pack;
        return pack.length == 1 && pack[0] == functionName;
      }
      
      return switch (type) 
      {
        case TInst(t, p):
          var pack = t.get().pack;
          // check if function type parameter and not already collected.
          if (isFunctionTypeParameter(t.get()) && !found.any(Types.eq.partial2(type))) 
            found.appendElem(type);
          else 
            searchInParams(p);
        case TEnum(_, p), TType(_, p):
          searchInParams(p);
        case TFun(args, ret):
          var res = args.foldLeft(function (acc, cur) return loop(cur.t, acc), found);
          loop(ret, res);
        case TAnonymous(a):
          a.get().fields.foldLeft(function (acc, cur) return loop(cur.type, acc), found);
        
        case TDynamic(t): loop(t, found);
        case TLazy(t): loop(t(), found);
        case TMono(_): found;
      }
    }
    return loop(type, []);
  }
  
  public static function getLocalClassTypeParameters (type:Type):Array<Type>
  {
    function getClassTypeParams (x:ClassType) return getClassTypeParameters(type, x.pack, x.name);
    
    return getLocalClassAsClassType()
      .map(getClassTypeParams)
      .getOrElse(function () return []);
  }
  
  public static function getLocalTypeParameters (type:Type):Array<Type>
  {
    return getLocalClassTypeParameters(type)
      .union(getLocalMethodTypeParameters(type), Types.eq);
  }
  
  public static function getLocalMethodTypeParameters (type:Type):Array<Type>
  {
    return getLocalMethod()
      .map(function (x) return getFunctionTypeParameters(type, x))
      .getOrElse(function () return []);
  }
  
  public static function getClassTypeParameters (type:Type, pack:Array<String>, name:String):Array<Type>
  {
    var cpack = pack.appendElem(name);
    function loop (type:Type, found:Array<Type>) 
    {
      return switch (type) 
      {
        case TInst(t, params):
          var tget = t.get();
          if (tget.pack.length == cpack.length 
              && Arrays.eq(tget.pack, cpack, Strings.eq) 
              && !found.any(function (x) return Types.eq(x, type)))
            found.concat([type]);
          else
            params.foldLeft(function (acc, cur) return loop(cur, acc), found);
        case TEnum(t, params):
          params.foldLeft(function (acc, cur) return loop(cur, acc), found);
        case TFun(args, ret):
          var r = args.foldLeft(function (acc, cur) return loop(cur.t, acc), found);
          loop(ret, r);
        case TAnonymous(a):
          a.get().fields.foldLeft(function (acc, cur) return loop(cur.type, acc), found);
        case TType(t, params):
          params.foldLeft(function (acc, cur) return loop(cur, acc), found);
        case TDynamic(t):
          loop(t, found);
        case TLazy(t):
          loop(t(), found);
        case TMono(t):
          found;
      }
    }
    return loop(type, []);
  }
  
  public static function getLocalClassAsType ():Option<Type>
  {
    return Ctx.getLocalType().nullToOption();
  }
  
  public static function getLocalClassAsClassType ():Option<ClassType> 
  {
    return 
      Ctx.getLocalClass()
      .nullToOption()
      .map(function (x) return x.get());
  }
  
  /**
   * Returns the method name in which the current macro is executed as a 'Some'
   * or 'None' if the macro is not executed inside of a method.
   * 
   * @return 
   */
  public static function getLocalMethod ():Option<String> 
  {
    var lc = Ctx.getLocalClass().nullToOption();
    
    function findInClassType (x:Ref<ClassType>) 
    {
      var types = Ctx.getModule(x.get().module);
      var pos = Ctx.getPosInfos(Ctx.currentPos());
      var min = pos.min;
      
      function getAllFields (t:Type) return switch (t) 
      {
        case TInst(t1, params):
          var tget = t1.get();
          var tpos = Ctx.getPosInfos(tget.pos);
          // TODO this is a hack because in display mode the min and max positions of the current class 
          // are wrong (report issue), so we don't filter anything out here
          if (#if display true #else min.inRange(tpos.min, tpos.max) #end) 
          {
            var constructor = tget.constructor.nullToArray().map(function (x) return x.get());
            
            constructor
            .concat(tget.fields.get())
            .concat(tget.statics.get());

          } else [];
        default: [];
      }
      
      function checkIfFieldIsLocalMethod(f:ClassField) 
      {
        var fpos = Ctx.getPosInfos(f.pos);
        return min.inRange(fpos.min, fpos.max);
      }
      
      return types.flatMap(getAllFields).some(checkIfFieldIsLocalMethod).map(function (x) return x.name);
    }
    
    return lc.flatMap(findInClassType);
  }
  
  
	public static function error(msg:Dynamic, pos:Position) 
	{
		if (Ctx.defined("display")) throw msg;
		Ctx.error(msg, pos);
	}
	
  
  public static function isTypeable (expr:Expr):Bool return typeof(expr).isSome()
  
	public static function typeof(expr:Expr):Option<Type>
	{
		return 
      try               Some(Ctx.typeof(expr))
      catch (e:Dynamic) None;
		
	}
	
  public static function getType2( pack:Array<String>, module:String, name:String ):Option<Type> 
  {
    return 
      if (module.length > 0) 
        getType(module + "." + name)
      else
        getType(name);
  }
  
  public static function getType( s:String ) : Option<Type> 
  {
    var parts = s.split(".");
    var len = parts.length;
    
    function isTypeInModule () 
    {
      return len >= 2 && { var p = parts[len - 2].charAt(0); p == p.toUpperCase(); }
    }
    return if (isTypeInModule()) // in module resolution
    {
      // type in module
      var p = parts.copy();
      var typeName = p.last();
      var module = p.removeLast().join(".");
      
      var types = try Some(Ctx.getModule(module)) catch (e:Dynamic) None;
      
      function findTypeInModuleTypes (types:Array<Type>) 
      {
        function typeFilter(t:Type) return switch (t) 
        {
          case TInst(t, _): t.get().name == typeName;
          case TEnum(t, _): t.get().name == typeName;
          case TType(t, _): t.get().name == typeName;
          default: false;
        }
        
        var filtered = types.filter(typeFilter);
        
        return filtered.length == 1 ? Some(filtered[0]) : None;
      }
      types.flatMap(findTypeInModuleTypes);
    } 
    else // normal resolution
    {
      try Some(Ctx.getType(s)) catch (e:Dynamic) None;
    }
  }
  
	public static function parse( expr : String, ?pos : Position ) : Validation<Error, Expr> 
  {
		var p = pos == null ? Ctx.currentPos() : pos;
		
    return try      Ctx.parse(expr, p).toSuccess()
    catch (e:Error) e.toFailure();
	}
	
  
  static var typeCache:Hash<Array<TypeCacheKey>> = new Hash();
  
	static public function getTypesFromClasspath (path:String, ?filter: TypeCacheKey->Bool)
    :Array<TypeCacheKey>
	{
    return if (typeCache.exists(path)) 
    {
      typeCache.get(path);
    } 
    else 
    {
      if (filter == null) filter = function (_) return true;
      var hxPattern = ~/^(.+).hx$/;
      
      var allTypes = [];
      
      function readDirectory (path, pack:Array<String>) 
      {
        var paths = FileSystem.readDirectory(path);
        
        for (p in paths) 
        {
          var absolutePath = path + "/" + p;
          
          if (FileSystem.isDirectory(absolutePath)) 
          {
            var newPack = pack.copy();
            newPack.push(p);
            readDirectory(absolutePath, newPack);
          } 
          else 
          {
            // is file
            if (hxPattern.match(p)) 
            {
              var types = getTypesFromFile(absolutePath, pack, hxPattern.matched(1), filter);
              allTypes = allTypes.concat(types);
            }
          }
        }
      }
      readDirectory(path, []);
      typeCache.set(path, allTypes);
      allTypes;
    }
    
    
		
	}
	
	static function matchAll (ereg:EReg, str:String, f:EReg->Option<TypeCacheKey>):Array<TypeCacheKey> 
  {
    var res = [];
    
		while (ereg.match(str)) 
    {
      switch (f(ereg)) 
      {
        case Some(v): res.push(v);
        case None:
      }
			str = ereg.matchedRight();
		}
    return res;
	}
	
	static public function getTypesFromFile (file:String, pack:Array<String>, moduleName:String, ?filter: TypeCacheKey->Bool):Array<TypeCacheKey>
  {
		var typeFilter = filter.nullGetOrElseConst(Predicates.constTrue1);
    
		var content = File.getContent(file);

    var packStr = pack.join(".");
    
    return 
      if (content.indexOf("package " + packStr + ";") == -1) 
        []
      else 
      {
        function f(type:TypeKind, e:EReg):Option<TypeCacheKey> 
        {
          var isPrivate = e.matched(1) == "private";
          var typeName = e.matched(2);
          
          var packStr = (pack.length > 0) ? (packStr + ".") : "";
          var moduleStr = (isPrivate ? "_" + moduleName + "." : "");
          
          var typeStr = typeName;
          
          var entry = { name:packStr + moduleStr + typeStr, type:type, isPrivate:isPrivate };
          
          return 
            if (typeFilter(entry)) Some(entry)
            else                   None;
        }
        
        var enumPattern = ~/^[ \r\n\t]*(private )?[ \r\n\t]*enum[ \r\n\t]*([A-Za-z0-9_]+)/g;
        var classPattern = ~/^[ \r\n\t]*(private )?[ \r\n\t]*class[ \r\n\t]*([A-Za-z0-9_]+)/g;
        var interfacePattern = ~/^[ \r\n\t]*(private )?[ \r\n\t]*interface[ \r\n\t]*([A-Za-z0-9_]+)/g;
        var typedefPattern = ~/^[ \r\n\t]*(private )?[ \r\n\t]*typedef[ \r\n\t]*([A-Za-z0-9_]+)/g;
        var packPattern = ~/~package ([A-Za-z0-9_.]+)/g;
        
        
        return matchAll(enumPattern, content, f.partial1(TEnum))
        .concat( matchAll(classPattern, content, f.partial1(TClass)) )
        .concat( matchAll(typedefPattern, content, f.partial1(TTypedef)) )
        .concat( matchAll(interfacePattern, content, f.partial1(TInterface)) );
      }
	}
  
  public static function getUsings(file:String, maxPosInFile:Int):Array<String> 
  {

    var content = neko.io.File.getContent(file);
    
    // TODO remove possible using statements in comments, best overwrite all comment chars with spaces
    
    var e = ~/using[ ]*([a-zA-Z0-9._]+)[ ]*;/;
    
    var res = [];
    while (e.match(content) && e.matchedPos().pos <= maxPosInFile) {
      res.push(e.matched(1));
      content = e.matchedRight();
    }
    
    return res;
  }
  
  public static function getImports(file:String, maxPosInFile:Int):Array<String> 
  {
    var content = neko.io.File.getContent(file);
    
    // TODO remove possible import statements in comments, best overwrite all comment chars with spaces
    
    var e = ~/import[ ]*([a-zA-Z0-9._]+)[ ]*;/;
    
    var res = [];
    
    while (e.match(content) && e.matchedPos().pos <= maxPosInFile) 
    {
      res.push(e.matched(1));
      content = e.matchedRight();
    }
    
    return res;
  }
	
  public static function followAliases (t:Type):Type
  {
    // TODO This is a workaround because it seems that haxe.macro.Context.follow throws an error for functions (StdTypes.Int -> hots.In)
    
    function isFunOrAnonymous (t:Type) return switch (t) 
    {
      case TAnonymous(_), TFun(_): return true;
      default:
    }
    
    return 
      if (isFunOrAnonymous(t)) t 
      else 
      {
        var c = t;
        var next = t;
        var isAlias = true;
        do 
        {
          c = next;
          next = Ctx.follow(c, true);
          isAlias = !isFunOrAnonymous(next);
        } while (isAlias && !Types.eq(c, next));
        
        return c;
      }
  }
  
}


#end