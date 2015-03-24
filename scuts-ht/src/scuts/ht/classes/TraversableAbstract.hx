package scuts.ht.classes;
import scuts.ht.classes.Foldable;
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

  public function sequence <M,A> (val:T<M<A>>, monad:Monad<M>):M<T<A>> return mapM(val, Scuts.id, monad);

  public function sequenceA <F,A> (val:T<F<A>>, app:Applicative<F>):F<T<A>> return traverse(val, Scuts.id, app);

  public function traverse <F,A,B> (v:T<A>, f:A->F<B>, app:Applicative<F>):F<T<B>> return sequenceA(map(v,f), app);

  public function mapM <M,A,B> (v:T<A>, f:A->M<B>, monad:Monad<M>):M<T<B>> return Scuts.abstractMethod();


  // functor delegation

  public inline function map<A,B>(val:T<A>, f:A->B):T<B> return fu.map(val,f);

  // foldable delegation

  public inline function fold <A>(of:T<A>, mon:Monoid<A>):A return fo.fold(of, mon);

  public inline function foldMap <A,B>(of:T<A>, f:A->B, mon:Monoid<B>):B return fo.foldMap(of, f, mon);

  public inline function foldLeft <A,B>(of:T<B>, b:A, f:A->B->A):A return fo.foldLeft(of,b,f);

  public inline function foldRight <A,B>(of:T<A>, b:B, f:A->B->B):B return fo.foldRight(of,b,f);

  public inline function foldLeft1 <A>(of:T<A>, f:A->A->A):A return fo.foldLeft1(of, f);

  public inline function foldRight1 <A>(of:T<A>, f:A->A->A):A return fo.foldRight1(of, f);

}