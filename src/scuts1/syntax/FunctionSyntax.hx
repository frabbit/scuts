
package scuts1.syntax;

import scuts1.core.Hots;
import scuts1.core.In;
import scuts1.core.OfOf;

class FunctionSyntax {

	public static inline function toFunction <A,B>(x:OfOf<In->In, A, B>):A->B return Hots.safeCast(cast x, var _ : A->B);

}