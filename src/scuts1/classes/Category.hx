package scuts1.classes;
import scuts1.core.OfOf;

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
  public function id <A>(a:A):OfOf<Cat, A, A>;
  /**
   * Category composition Operator.
   * 
   * Haskell: aka (.)
   */
  public function dot <A,B,C>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>):OfOf<Cat, A, C>;
  
  /**
   * Left-to-right composition (Haskell Source)
   * 
   * Haskell: (>>>) :: Category cat => cat a b -> cat b c -> cat a c
   */
  public function next <A,B,C>(f:OfOf<Cat, A, B>, g:OfOf<Cat, B, C>):OfOf<Cat,A, C>;
  
  /**
   * Right-to-left composition (Haskell Source)
   * 
   * Haskell: (<<<) :: Category cat => cat b c -> cat a b -> cat a c
   */
  public function back <A,B,C>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>):OfOf<Cat,A, C>;
  
}
