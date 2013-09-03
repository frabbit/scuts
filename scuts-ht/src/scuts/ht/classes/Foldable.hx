package scuts.ht.classes;
import scuts.ht.core.Of;
import scuts.ht.classes.Monoid;




/*
 * The foldable instance provides various fold operations 
 * for data structures that can be folded.
 * 
 * minimal implementation: foldRight or foldMap
 * 
 */
interface Foldable<F>
{
  
  /**
   * Performs a right fold over the value x, where mon
   * provides a function for appending the elements and a zero-Element.
   * 
   * Haskell: fold :: Monoid m => t m -> m
   */
  public function fold <A>(x:Of<F,A>, mon:Monoid<A>):A;
  
  
  /**
   * Performs a fold over x, where f produces
   * the initial value out of the first element of type A and mon
   * provides a function for appending the other elements and a Zero-Element.
   * 
   * Haskell Signature: Monoid b => (a -> b) -> f a -> b
   */
  public function foldMap <A,B>(x:Of<F,A>, f:A->B, mon:Monoid<B> ):B;
 
  /**
   * Performs a left fold over x, where init is the initial value
   * and f the accumulating function.
   * 
   * Haskell: foldl :: (a -> b -> a) -> a -> f b -> A 
   */
  public function foldLeft <A,B>(x:Of<F,B>, init:A, f:A->B->A):A;
  
  /**
   * Performs a right fold over x, where init is the initial value
   * and f the accumulating function.
   * 
   * Haskell: foldr :: (a -> b -> b) -> b -> t a -> b
   */
  public function foldRight <A,B>(x:Of<F,A>, init:B, f:A->B->B):B;
  
  /**
   * Performs a left fold over x, where f is the accumulating function.
   * In contrast to foldLeft no init must be specified, but this function
   * fails if the value x has no Elements of type A.
   * 
   * Haskell: foldl1 :: (a -> a -> a) -> t a -> a
   * 
   */
  public function foldLeft1 <A>(x:Of<F,A>, f:A->A->A):A;
  
  /**
   * Performs a right fold over x, where f is the accumulating function.
   * In contrast to rightLeft no init must be specified, but this function
   * fails if the value x has no Elements of type A.
   * 
   * Haskell: foldr1 :: (a -> a -> a) -> t a -> a
   */
  public function foldRight1 <A>(x:Of<F,A>, f:A->A->A):A;
  
  
}