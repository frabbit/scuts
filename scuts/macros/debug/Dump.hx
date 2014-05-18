package scuts.macros.debug;
#if false

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import scuts.mcore.Parse;
import scuts.mcore.Print;
#end

class Dump 
{

  macro public static function dump(a:Expr, ?msg:String):Expr 
	{

		var info = objInfo(a);
		var s = 'trace(' + (if (msg != null) '$msg + " | " + ' else "") + ' Std.string($info) )';
		
		var res = Parse.parse(s, { info:info, msg:msg } );
		return res;
	}
	
	macro public static function dumpObject(a:Expr) 
	{
		return objInfo(a);
	}
	
	#if macro
	public static function objInfo(a:Expr) 
	{
		var expr = Print.expr(a);
		var t = Context.typeof(a);
		var realType = Context.follow(t, false);
		return Parse.parse('"(name: " + $a + " | value: " + Std.string($c) + " | type: " + $b + " realType: " + $realtype + " | runTimeType: " + Type.typeof($c) + ")"', 
			{a:expr, b:TypePrinter.type(t), c:a, realtype:Print.type(realType)});
	}
	#end
  
}
#end