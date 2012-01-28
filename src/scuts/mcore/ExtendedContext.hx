package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

//using scuts.Core;
import scuts.CoreTypes;




import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.Stack;
import neko.FileSystem;
import neko.io.File;




enum TypeType {
	TClass;
	TTypedef;
	TEnum;
  TInterface;
}
 
class ExtendedContext 
{

	public static function error(msg:Dynamic, pos:Position) 
	{
    
		if (Context.defined("display")) 
		{
			throw msg;
		}
		Context.error(msg, pos);
	}
	
	public static function typeof(expr:Expr):Option<Type>
	{
		return try {
			Some(Context.typeof(expr));
		} catch (e:Dynamic) {
			None;
		}
	}
	
	public static function parse( expr : String, ?pos : Position ) : Expr {
		var pos = pos == null ? Context.currentPos() : pos;
		return try {
			//trace("try parse");
			var r = Context.parse(expr, pos);
			//trace("end parse");
			r;
		} catch (e:Dynamic) {
			if (Context.defined("debug")) {
				trace(Stack.toString(Stack.callStack()));
			}
			throw e;
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