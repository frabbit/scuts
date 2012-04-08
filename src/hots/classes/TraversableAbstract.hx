package hots.classes;
import hots.OfOf;
import hots.Of;
import hots.classes.Foldable;
import scuts.Scuts;

@:tcAbstract class TraversableAbstract<T> implements Traversable<T>
{
  var fu:Functor<T>;
  var fo:Foldable<T>;
  
  public function new (functor:Functor<T>, foldable:Foldable<T>) {
    this.fu = functor;
    this.fo = foldable;
  }
  
  public function sequence <M,A> (val:Of<T, Of<M,A>>, monad:Monad<M>):Of<M, Of<T,A>> return mapM(Scuts.id, val, monad)
  
  public function sequenceA <F,A> (val:Of<T, Of<F,A>>, app:Applicative<F>):Of<F, Of<T,A>> return traverse(Scuts.id, val, app)
  
  public function traverse <F,A,B> (f:A->Of<F,B>, v:Of<T,A>, app:Applicative<F>):Of<F, Of<T,B>> return sequenceA(map(f,v), app)
  
  public function mapM <M,A,B> (f:A->Of<M,B>, v:Of<T,A>, monad:Monad<M>):Of<M, Of<T,B>> return Scuts.abstractMethod()
  
  
  // functor delegation
  
  @:final public inline function map<A,B>(f:A->B, val:Of<T,A>):Of<T,B> return fu.map(f, val)
  
  // foldable delegation
  
  @:final public inline function fold <A>(mon:Monoid<A>, val:Of<T,A>):A return fo.fold(mon, val)
  
  @:final public inline function foldMap <A,B>(f:A->B, mon:Monoid<B>, val:Of<T,A>):B return fo.foldMap(f, mon, val)
 
  @:final public inline function foldLeft <A,B>(f:A->B->A, b:A, val:Of<T,B>):A return fo.foldLeft(f,b,val)
  
  @:final public inline function foldRight <A,B>(f:A->B->B, b:B, val:Of<T,A>):B return fo.foldRight(f,b,val)
  
  @:final public inline function foldLeft1 <A>(f:A->A->A, val:Of<T,A>):A return fo.foldLeft1(f, val)
  
  @:final public inline function foldRight1 <A>(f:A->A->A, val:Of<T,A>):A return fo.foldRight1(f, val)
  
}