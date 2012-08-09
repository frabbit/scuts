package hots.classes;
import hots.OfOf;
import hots.Of;
import hots.classes.Foldable;
import scuts.Scuts;

class TraversableAbstract<T> implements Traversable<T>
{
  var fu:Functor<T>;
  var fo:Foldable<T>;
  
  public function new (functor:Functor<T>, foldable:Foldable<T>) 
  {
    this.fu = functor;
    this.fo = foldable;
  }
  
  public function sequence <M,A> (val:Of<T, Of<M,A>>, monad:Monad<M>):Of<M, Of<T,A>> return mapM(val, Scuts.id, monad)
  
  public function sequenceA <F,A> (val:Of<T, Of<F,A>>, app:Applicative<F>):Of<F, Of<T,A>> return traverse(val, Scuts.id, app)
  
  public function traverse <F,A,B> (v:Of<T,A>, f:A->Of<F,B>, app:Applicative<F>):Of<F, Of<T,B>> return sequenceA(map(v,f), app)
  
  public function mapM <M,A,B> (v:Of<T,A>, f:A->Of<M,B>, monad:Monad<M>):Of<M, Of<T,B>> return Scuts.abstractMethod()
  
  
  // functor delegation
  
  public inline function map<A,B>(val:Of<T,A>, f:A->B):Of<T,B> return fu.map(val,f)
  
  // foldable delegation
  
  public inline function fold <A>(of:Of<T,A>, mon:Monoid<A>):A return fo.fold(of, mon)
  
  public inline function foldMap <A,B>(of:Of<T,A>, mon:Monoid<B>, f:A->B):B return fo.foldMap(of, mon, f)
 
  public inline function foldLeft <A,B>(of:Of<T,B>, b:A, f:A->B->A):A return fo.foldLeft(of,b,f)
  
  public inline function foldRight <A,B>(of:Of<T,A>, b:B, f:A->B->B):B return fo.foldRight(of,b,f)
  
  public inline function foldLeft1 <A>(of:Of<T,A>, f:A->A->A):A return fo.foldLeft1(of, f)
  
  public inline function foldRight1 <A>(of:Of<T,A>, f:A->A->A):A return fo.foldRight1(of, f)
  
}