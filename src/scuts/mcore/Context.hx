package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

//using scuts.Core;
import haxe.macro.Compiler;
import scuts.core.extensions.ArrayExt;
import scuts.core.extensions.IntExt;
import scuts.core.extensions.StringExt;
import scuts.core.Log;
import scuts.CoreTypes;
import scuts.mcore.extensions.TypeExt;
import scuts.Scuts;


using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.OptionExt;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.Stack;
import neko.FileSystem;
import neko.io.File;
using scuts.core.extensions.IntExt;
using scuts.core.extensions.DynamicExt;
using scuts.core.extensions.OptionExt;
using scuts.core.Log;
using scuts.mcore.extensions.TypeExt;
using scuts.core.extensions.StringExt;


private typedef Ctx = haxe.macro.Context;

enum TypeType {
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
      return switch (type) 
      {
        case TInst(t, params):
          var tget = t.get();
          if (tget.pack.length == 1 && tget.pack[0] == functionName 
              && !found.any(function (x) return TypeExt.eq(x, type))) 
            found.concat([type]);
          else 
            params.foldLeft(function (acc, cur) return loop(cur, acc), found);
        case TEnum(t, params):
          params.foldLeft(function (acc, cur) return loop(cur, acc), found);
        case TFun(args, ret):
          var res = args.foldLeft(function (acc, cur) return loop(cur.t, acc), found);
          loop(ret, res);
        case TAnonymous(a):
          a.get().fields.foldLeft(function (acc, cur) return loop(cur.type, acc), found);
        case TType(t, params):
          params.foldLeft(function (acc, cur) return loop(cur, acc), found);
        case TDynamic(t): loop(t, found);
        case TLazy(t): loop(t(), found);
        case TMono(t): found;
      }
    }
    return loop(type, []);
  }
  
  public static function getLocalClassTypeParameters (type:Type):Array<Type>
  {
    return getLocalClassAsClassType()
      .map(function (x) return getClassTypeParameters(type, x.pack, x.name))
      .getOrElse(function () return []);
  }
  
  public static function getLocalTypeParameters (type:Type):Array<Type>
  {
    return getLocalClassTypeParameters(type)
      .union(getLocalMethodTypeParameters(type), TypeExt.eq);
  }
  
  public static function getLocalMethodTypeParameters (type:Type):Array<Type>
  {
    return getLocalMethod()
      .map(function (x) return getFunctionTypeParameters(type, x))
      .getOrElse(function () return []);
  }
  
  public static function getClassTypeParameters (type:Type, pack:Array<String>, name:String):Array<Type>
  {
    var cpack = pack.insertElemBack(name);
    function loop (type:Type, found:Array<Type>) 
    {
      return switch (type) 
      {
        case TInst(t, params):
          var tget = t.get();
          if (tget.pack.length == cpack.length 
              && ArrayExt.eq(tget.pack, cpack, StringExt.eq) 
              && !found.any(function (x) return TypeExt.eq(x, type)))
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
    // TODO this was a hack because getLocalClass was returning the Main Type of a Module in a case, but i can't reproduce now.
    /*
    var lc = Ctx.getLocalClass().nullToOption();
    return lc.flatMap(function (x) {
      
      var types = Ctx.getModule(x.get().module);
      var pos = Ctx.getPosInfos(Ctx.currentPos());
      var min = pos.min;
      return types.some(function (t) {
          return switch (t) {
            case TInst(t1, params):
              var tget = t1.get();
              var tpos = Ctx.getPosInfos(tget.pos);
              
              min.inRange(tpos.min, tpos.max);
            default: false;
          };
      });
    });
    */
  }
  
  public static function getLocalClassAsClassType ():Option<ClassType> 
  {
    return Ctx.getLocalClass()
      .nullToOption()
      .map(function (x) return x.get());
      
    // related to the hack i cannot reproduce anymore, see getLocalClassAsType
    /*
    return getLocalClassAsType().map(function (x) {
      return switch (x) {
        case TInst(t1,_):
          t1.get();
        default: Scuts.unexpected();
      }
    });
    */
  }
  
  /**
   * Returns the method name in which the current macro is executed as a 'Some'
   * or 'None' if the macro is not executed inside of a method.
   * 
   * @return 
   */
  public static function getLocalMethod ():Option<String> {
    var lc = Ctx.getLocalClass().nullToOption();
    return lc.flatMap(function (x) {
      
      var types = Ctx.getModule(x.get().module);
      var pos = Ctx.getPosInfos(Ctx.currentPos());
      var min = pos.min;
      return 
        types.flatMap(function (t) {
          return switch (t) {
            case TInst(t1, params):
              var tget = t1.get();
              var tpos = Ctx.getPosInfos(tget.pos);
              // TODO this is a hack because in display mode the min and max positions of the current class are wrong (report issue), so we don't filter anything out here
              if (#if display true #else min.inRange(tpos.min, tpos.max) #end) {
                tget.constructor.nullToArray()
                .map(function (x) return x.get())
                .concat(tget.fields.get())
                .concat(tget.statics.get());

              } else [];
            default: [];
          }
        })
        .some(function (f) {
          var fpos = Ctx.getPosInfos(f.pos);
          return min.inRange(fpos.min, fpos.max);
        })
        .map(function (x) return x.name);
    });
  }
  
  
	public static function error(msg:Dynamic, pos:Position) 
	{
    
		if (Ctx.defined("display")) 
		{
			throw msg;
		}
		Ctx.error(msg, pos);
	}
	
	public static function typeof(expr:Expr):Option<Type>
	{
		return try {
			Some(Ctx.typeof(expr));
		} catch (e:Dynamic) {
			None;
		}
	}
	
  public static function getType2( pack:Array<String>, module:String, name:String ):Option<Type> {
    return 
      if (module.length > 0) 
        getType(module + "." + name)
      else
        getType(name);
  }
  
  public static function getType( s:String ) : Option<Type> {
    var parts = s.split(".");
    return if (parts.length >= 2 
      && parts[parts.length-2].charAt(0) == parts[parts.length-2].toUpperCase().charAt(0)) // in module resolution
    {
        
        // type in module
        var p = parts.copy();
        var typeName = p.last();
        var module = p.removeLast().join(".");
        var types = try Some(Ctx.getModule(module)) catch (e:Dynamic) None;
        types.flatMap(function (types) {
          
          var filtered = types.filter(function (t)
            return switch (t) {
              case TInst(t, _):
                t.get().name == typeName;
              case TEnum(t, _):
                t.get().name == typeName;
              case TType(t, _):
                t.get().name == typeName;
              default: false;
            }
          );
          
          return filtered.length == 1 ? Some(filtered[0]) : None;
        });
      
    } 
    else // normal resolution
    {
      try Some(Ctx.getType(s)) catch (e:Dynamic) None;
    }
  }
  
	public static function parse( expr : String, ?pos : Position ) : Either<Error, Expr> {
		var pos = pos == null ? Ctx.currentPos() : pos;
		return try {
			//trace("try parse");
			var r = Ctx.parse(expr, pos);
			//trace("end parse");
			Right(r);
		} catch (e:Error) {
      Left(e);
			
		}
	}
	
  
  static var typeCache:Hash<Array<{ name:String, type:TypeType, isPrivate:Bool}>> = new Hash();
  
	static public function getTypesFromClasspath (path:String, ?filter:{name:String, type:TypeType, isPrivate:Bool}->Bool):Array<{ name:String, type:TypeType, isPrivate:Bool}>
	{
    if (typeCache.exists(path)) {
      return typeCache.get(path);
    }
    
		if (filter == null) filter = function (_) return true;
		var hxPattern = ~/^(.+).hx$/;
		
		var allTypes = [];
		
		function readDirectory (path, pack:Array<String>) {
			var paths = FileSystem.readDirectory(path);
			
			for (p in paths) {
				var absolutePath = path + "/" + p;
				
				if (FileSystem.isDirectory(absolutePath)) {
					var newPack = pack.copy();
					newPack.push(p);
					readDirectory(absolutePath, newPack);
				} else {
					// is file
					if (hxPattern.match(p)) {
						var types = getTypesFromFile(absolutePath, pack, hxPattern.matched(1), filter);
						allTypes = allTypes.concat(types);
						
					}
					 
				}
			}
			
		}
    
    
		readDirectory(path, []);
    typeCache.set(path, allTypes);
		return allTypes;
	}
	
	static function matchAll (ereg:EReg, str:String, f:EReg->Void) {
		while (ereg.match(str)) {
			f(ereg);
			str = ereg.matchedRight();
		}
	}
	
	static public function getTypesFromFile(
		file:String, pack:Array<String>, moduleName:String, ?filter:{name:String, type:TypeType, isPrivate:Bool}->Bool
		)
		:Array<{ name:String, type:TypeType, isPrivate:Bool}>
	{
		if (filter == null) filter = function (_) return true;
		var content = File.getContent(file);
		
		var enumPattern = ~/^[ \r\n\t]*(private )?[ \r\n\t]*enum[ \r\n\t]*([A-Za-z0-9_]+)/g;
		var classPattern = ~/^[ \r\n\t]*(private )?[ \r\n\t]*class[ \r\n\t]*([A-Za-z0-9_]+)/g;
    var interfacePattern = ~/^[ \r\n\t]*(private )?[ \r\n\t]*interface[ \r\n\t]*([A-Za-z0-9_]+)/g;
		var typedefPattern = ~/^[ \r\n\t]*(private )?[ \r\n\t]*typedef[ \r\n\t]*([A-Za-z0-9_]+)/g;
    var packPattern = ~/~package ([A-Za-z0-9_.]+)/g;
		var types = [];
		
    if (content.indexOf("package " + pack.join(".") + ";") == -1) {
      return types;
    }
    
		function f(type:TypeType, e:EReg) {
			var isPrivate = e.matched(1) == "private";
			var typeName = e.matched(2);
			
			var packStr = (pack.length > 0) ? (pack.join(".") + ".") : "";
			var moduleStr = (isPrivate ? "_" + moduleName + "." : "");
			
			var typeStr = typeName;
			
			var entry = { name:packStr + moduleStr + typeStr, type:type, isPrivate:isPrivate };
			
			if (filter(entry)) {
				types.push(entry);
			}
		}
		
    
    
		matchAll(enumPattern, content, callback(f, TEnum));
		matchAll(classPattern, content, callback(f, TClass));
		matchAll(typedefPattern, content, callback(f, TTypedef));
		matchAll(interfacePattern, content, callback(f, TInterface));
		return types;
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
    while (e.match(content) && e.matchedPos().pos <= maxPosInFile) {
      //trace("matched");
      res.push(e.matched(1));
      content = e.matchedRight();
    }
    
    
    
    return res;
    
  }
	
}


#end