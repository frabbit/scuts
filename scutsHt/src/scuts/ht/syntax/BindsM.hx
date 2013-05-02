package scuts.ht.syntax;


import scuts.ht.core.Of;

#if macro
import haxe.macro.Expr;
import scuts.ht.macros.implicits.Resolver;
#end

class BindsM {

		
	//#if display
	//
	//public static function flatMap_ <M,A,B> (x:Of<M, A>, f:A->Of<M, B>):Of<M,B> return null;
	//
	//#else
	
	macro public static function flatMap_ <M,A,B> (x:ExprOf<Of<M, A>>, f:ExprOf<A->Of<M, B>>):ExprOf<Of<M,B>>
	{
		return Resolver.resolve(macro scuts.ht.syntax.Binds.flatMap, [x, f], 3);
	}
	
	//#end

	   
}

