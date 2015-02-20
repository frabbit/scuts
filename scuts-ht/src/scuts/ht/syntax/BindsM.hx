package scuts.ht.syntax;


import scuts.ht.core.Of;

#if macro
import haxe.macro.Expr;
import scuts.ht.macros.implicits.Resolver;
#end

class BindsM {


	//#if display
	//
	//public static function flatMap_ <M,A,B> (x:M<A>, f:A->M<B>):M<B> return null;
	//
	//#else

	macro public static function flatMap_ <M,A,B> (x:ExprOf<M<A>>, f:ExprOf<A->M<B>>):ExprOf<M<B>>
	{
		return Resolver.resolve(macro scuts.ht.syntax.Binds.flatMap, [x, f], 3);
	}

	//#end


}

