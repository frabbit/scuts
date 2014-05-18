
package scuts.ht.syntax;

import scuts.ht.core.Ht;
import scuts.ht.core.In;
import scuts.ht.core.OfOf;

class FunctionSyntax {

	public static inline function toFunction <A,B>(x:OfOf<In->In, A, B>):A->B return Ht.preservedCast(cast x);

}