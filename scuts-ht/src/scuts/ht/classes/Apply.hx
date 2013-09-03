package scuts.ht.classes;


import scuts.ht.core.Of;

import scuts.Scuts;

interface Apply<F> extends Functor<F>
{

  /**
   * Sequential Application. (Haskell Source)
   * 
   * Haskell: (<*>) :: f (a -> b) -> f a -> f b
   */
  public function apply<A,B>(fa:Of<F,A>, f:Of<F,A->B>):Of<F,B>;


  // derived functions, could be useful to override for performance

  // TODO add more apply and lift functions

  public function apply2 <A,B,C>(fa:Of<F,A>, fb:Of<F,B>, f:A->B->C):Of<F,C>;

  public function apply3 <A,B,C,D>(fa:Of<F,A>, fb:Of<F,B>, fc:Of<F,C>, f:A->B->C->D):Of<F,D>;
  

  public function lift2<A, B, C>(f: A -> B -> C): Of<F,A> -> Of<F,B> -> Of<F,C>;

  public function lift3<A, B, C,D>(f: A -> B -> C ->D): Of<F,A> -> Of<F,B> -> Of<F,C> -> Of<F,D>;
  
  
  public function ap<A,B>(fab:Of<F, A->B>):Of<F, A>->Of<F,B>;

}
