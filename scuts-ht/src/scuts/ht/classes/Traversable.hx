package scuts.ht.classes;
import scuts.ht.core.OfOf;
import scuts.ht.core.Of;
import scuts.ht.classes.Foldable;




interface Traversable<T> extends Functor<T> extends Foldable<T>
{
  // functions
  public function sequence <M,A> (val:T<M<A>>, monad:Monad<M>):M<T<A>>;

  public function sequenceA <F,A> (val:T<F<A>>, app:Applicative<F>):F<T<A>>;

  public function traverse <F,A,B> (v:T<A>, f:A->F<B>, app:Applicative<F>):F<T<B>>;

  public function mapM <M,A,B> (v:T<A>, f:A->M<B>, monad:Monad<M>):M<T<B>>;

}

