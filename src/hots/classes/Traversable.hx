package hots.classes;
import hots.OfOf;
import hots.Of;
import hots.classes.Foldable;




interface Traversable<T> implements Functor<T>, implements Foldable<T>
{
  // functions
  public function sequence <M,A> (val:Of<T, Of<M,A>>, monad:Monad<M>):Of<M, Of<T,A>>;
  
  public function sequenceA <F,A> (val:Of<T, Of<F,A>>, app:Applicative<F>):Of<F, Of<T,A>>;
  
  public function traverse <F,A,B> (v:Of<T,A>, f:A->Of<F,B>, app:Applicative<F>):Of<F, Of<T,B>>;
  
  public function mapM <M,A,B> (v:Of<T,A>, f:A->Of<M,B>, monad:Monad<M>):Of<M, Of<T,B>>;
  
}

