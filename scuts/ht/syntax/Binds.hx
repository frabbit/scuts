
package scuts.ht.syntax;

import scuts.ht.classes.Monad;
import scuts.ht.core.Of;

class Binds {

	public static inline function flatMap <M,A,B> (x:Of<M, A>, f:A->Of<M, B>, m:Monad<M>):Of<M,B> return m.flatMap(x, f);

}