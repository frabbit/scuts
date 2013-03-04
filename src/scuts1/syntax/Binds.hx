
package scuts1.syntax;

import scuts1.classes.Monad;
import scuts1.core.Of;

#if macro
import haxe.macro.Expr;
import scuts1.macros.implicits.Resolver;
#end

class Binds {

	public static inline function flatMap <M,A,B> (x:Of<M, A>, f:A->Of<M, B>, m:Monad<M>):Of<M,B> return m.flatMap(x, f);


	#if display
	public static inline function flatMap_ <M,A,B> (x:Of<M, A>, f:A->Of<M, B>):Of<M,B> return null;
	#else
	macro public static inline function flatMap_ <M,A,B> (x:ExprOf<Of<M, A>>, f:ExprOf<A->Of<M, B>>):ExprOf<Of<M,B>>
	   return Resolver.resolve(macro scuts1.syntax.Binds.flatMap, [x, f]);
	#end
}