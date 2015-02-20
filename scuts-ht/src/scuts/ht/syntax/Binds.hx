
package scuts.ht.syntax;

import scuts.ht.classes.Monad;

class Binds {

	public static inline function flatMap <M,A,B> (x:M<A>, f:A->M<B>, m:Monad<M>):M<B> return m.flatMap(x, f);

}