package scuts.ht.classes;

import scuts.Scuts;

interface Apply<F> extends Functor<F>
{

  /**
   * Sequential Application. (Haskell Source)
   *
   * Haskell: (<*>) :: f (a -> b) -> f a -> f b
   */
  public function apply<A,B>(fa:F<A>, f:F<A->B>):F<B>;


  // derived functions, could be useful to override for performance

  // TODO add more apply and lift functions

  public function apply2 <A,B,C>(fa:F<A>, fb:F<B>, f:A->B->C):F<C>;

  public function apply3 <A,B,C,D>(fa:F<A>, fb:F<B>, fc:F<C>, f:A->B->C->D):F<D>;


  public function lift2<A, B, C>(f: A -> B -> C): F<A> -> F<B> -> F<C>;

  public function lift3<A, B, C,D>(f: A -> B -> C ->D): F<A> -> F<B> -> F<C> -> F<D>;


  public function ap<A,B>(fab:F<A->B>):F<A>->F<B>;

}
