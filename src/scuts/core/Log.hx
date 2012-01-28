package scuts;
import haxe.PosInfos;

class Log 
{

  
	public static  function traced <T>(v:T, ?show:T->String, ?pos:PosInfos):T {
    #if debug
    var t = if (show != null) show(v) else Std.string(v);
    haxe.Log.trace(t, pos);
    #end
    return v;
  }
	
  /*
	@:macro public static function dump(a:Expr, ?msg:String):Expr 
	{

		var info = objInfo(a);
		var s = 'trace(' + (if (msg != null) '$msg + " | " + ' else "") + ' Std.string($info) )';
		
		var res = ExprParser.parse(s, { info:info, msg:msg } );
		return res;

		//var res = ExprParser.parse('trace("hi" + "bla" + Std.string({ a:10, b:"hi", }))');
		//trace(ExprPrinter.exprStr(res));
		
	}
	
	@:macro public static function dumpObject(a:Expr) 
	{
		return objInfo(a);
	}
	
	#if macro
	public static function objInfo(a:Expr) 
	{
		var exprStr = ExprPrinter.exprStr(a);
		var t = Context.typeof(a);
		var realType = Context.follow(t, false);
		return ExprParser.parse('"(name: " + $a + " | value: " + Std.string($c) + " | type: " + $b + " realType: " + $realtype + " | runTimeType: " + Type.typeof($c) + ")"', 
			{a:exprStr, b:TypePrinter.typeStr(t), c:a, realtype:TypePrinter.typeStr(realType)});
	}
	#end
	*/
	
}