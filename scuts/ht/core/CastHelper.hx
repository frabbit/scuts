
package scuts.ht.core;

import haxe.macro.Expr;

class CastHelper {

	@:noUsing 
	#if !macro macro #end public static function preservedCast (e:Expr):Expr 
	{
	return macro (inline function () return $e)();
	}
	@:noUsing 
	#if !macro macro #end public static function checkType (e:Expr):Expr 
	{

	return switch (e.expr) {
	  case EVars([{ name : "_", type : t, expr : ex}]): { expr : ECheckType(ex, t), pos: e.pos};
	  case _ : throw "Unexpected";

	}

	return macro (function () return $e)();
	}

	@:noUsing public static function identity <T>(t:T):T {
	 return t;
	}

	@:noUsing 
	#if !macro macro #end public static function preservedCheckType (e:Expr):Expr 
	{
	return switch (e.expr) {
	  case EVars([{ name : "_", type : t, expr : ex}]) if (t != null): 
	    var e = macro (function ():$t return $ex)();
	    
	    return e;
	  case _ : throw "Unexpected";

	}

	}

}