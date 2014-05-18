package scuts.ht.syntax;


import scuts.core.Arrays;
import scuts.ht.classes.Monad;

import scuts.ht.syntax.Functors;
import scuts.Scuts;


typedef MonadsFunctors = Functors;

class Monads
{

	public static function flatten <M,A> (x:M<M<A>>, m:Monad<M>):M<A> return m.flatten(x);

	public static function flatMap <M,A,B> (x:Of<M, A>, f:A->Of<M, B>, m:Monad<M>):Of<M,B> return m.flatMap(x, f);

}



