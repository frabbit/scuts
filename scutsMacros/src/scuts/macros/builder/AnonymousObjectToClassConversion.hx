package scuts.macros.builder;


#if false

import haxe.macro.Expr;

#if macro

import scuts.mcore.Parse;
import scuts.mcore.Print;
import haxe.macro.Context;
import neko.FileSystem;
import neko.io.File;
using scuts.Core;
#end


#if (!macro && !display) extern #end
class AnonymousObjectToClassConversion 
{

	static var loadedClasses = new Hash();
	
	
	
	public static var classPrefix = #if debug "Scuts_Anon_" #else "AnonObjClass_" #end;
	
	public static function setCustomClassPrefix (prefix:String):Void {
		classPrefix = prefix;
	}
	
	@:macro public static function convert(e:ExprRequire<{}>, immutable:Bool = true) 
	{
		return anonToClass1(e, immutable);
	}
  
  public static function anonToClass1(e:Expr, immutable:Bool = false):Expr 
	{
		var pos = e.pos;
    
		switch (e.expr) {
			case EObjectDecl(fields):
				return mkAnonClass(fields, immutable);
			default: 
				Context.error("Only constant anonymous objects are allowed", pos);
				return null;
		}
		
	}
	
	static public function mkAnonClass(fields:Array<{field:String, expr:Expr}>, immutable:Bool = true):Expr 
	{
		var className = classPrefix;
		var clId =  (immutable ? "immutable" : "mutable") + "_";
		var publicFields = [];
		for ( f in fields) {
			clId += f.field + "_";
			
      switch (f.expr.expr) {
        case EObjectDecl(fields):
          // recursive
          var e1 = anonToClass1(f.expr, immutable);
          f.expr = e1;
        default:
      }
      
      var type = Print.type(Context.typeof(f.expr), true);
			
      
      
			clId += type + "_";
			
			publicFields.push( { f:f.field, t:type, e:f.expr } );
		}
		clId = clId.split(" -> ").join("_ar")
							 .split("<").join("_op")
							 .split(">").join("_cl")
							 .split("{").join("_oo")
							 .split("}").join("_oc")
							 .split(":").join("_col")
							 .split(",").join("_com")
							 .split(" ").join("_sp");
               
    
		className += Context.signature(clId);
    
    trace(className);
		if (!loadedClasses.exists(className)) {
			var cl = "class " + className + " {\n" + 
				publicFields.foldLeft( 
					function (acc, e) 
						return acc + "\n\tpublic var " + e.f + (immutable ? "(default, null)" : "") + ":" + e.t + ";", "")
				+ 
				"\n" +
				"\tpublic function new (" + 
				publicFields.foldLeftWithIndex( 
					function (acc, e, i) 
						return acc + ((i != 0) ? "," : "") + e.f + ":" + e.t
					, "") + 
				") {\n" + 
				publicFields.foldLeftWithIndex( 
					function (acc, e, i) 
						return acc + "\n\t\tthis." + e.f + " = " + e.f + ";"
					, "") + 
				"\n\t}" + 
				"\n}";
			var output = File.write(className + ".hx", false);
			output.writeString(cl);
			output.close();
			Context.getType(className);
			loadedClasses.set(className, true);
			//FileSystem.deleteFile(className + ".hx");
		}
		
		var ctx:Dynamic<Dynamic> = { };
		ctx.type = className;
		for (i in 0...publicFields.length) {
			Reflect.setField(ctx, "arg" + i, publicFields[i].e);
		}
		
		var e = Parse.parse(
					"new $type (" + 
						publicFields.foldLeftWithIndex( 
							function (acc, e, i) return acc + (i > 0 ? ", " : "") + "$arg" + i
							, "") 
						+ ")",
					ctx);
		
    trace("result: \n" + Print.expr(e));
		return e;
	}
	
}

#end