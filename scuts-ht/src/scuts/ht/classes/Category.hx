package scuts.ht.classes;

import scuts.Scuts;

/**
 *
 * The Haskell type class Category together with the combining functions (<<<) and (>>>):
 *
 *
 * instance Category (->) where
 *     id = Prelude.id
 *     (.) = (Prelude..)
 *
 * -- | Right-to-left composition
 * (<<<) :: Category cat => cat b c -> cat a b -> cat a c
 * (<<<) = (.)
 *
 * -- | Left-to-right composition
 * (>>>) :: Category cat => cat a b -> cat b c -> cat a c
 * f >>> g = g . f
 *
 *
*/
interface Category<Cat>
{
  public function id <A>(a:A):Cat<A, A>;
  /**
   * Category composition Operator.
   *
   * Haskell: aka (.)
   */
  public function dot <A,B,C>(g:Cat<B, C>, f:Cat<A, B>):Cat<A, C>;

  /**
   * Left-to-right composition (Haskell Source)
   *
   * Haskell: (>>>) :: Category cat => cat a b -> cat b c -> cat a c
   */
  public function next <A,B,C>(f:Cat<A, B>, g:Cat<B, C>):Cat<A, C>;

  /**
   * Right-to-left composition (Haskell Source)
   *
   * Haskell: (<<<) :: Category cat => cat b c -> cat a b -> cat a c
   */
  public function back <A,B,C>(g:Cat<B, C>, f:Cat<A, B>):Cat<A, C>;

}
