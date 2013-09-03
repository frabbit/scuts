package scuts.ht.classes;
import scuts.ht.core.OfOf;

import scuts.Scuts;



class CategoryAbstract<Cat> implements Category<Cat>
{
  public function id <A>(a:A):OfOf<Cat, A, A> return Scuts.abstractMethod();
  /**
   * aka (.)
   */
  public function dot <A,B,C>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>):OfOf<Cat, A, C> return Scuts.abstractMethod();
  
  /**
   * aka >>>
   */
  public function next <A,B,C>(f:OfOf<Cat, A, B>, g:OfOf<Cat, B, C>):OfOf<Cat,A, C> return dot(g,f);
  
  /**
   * aka <<<
   */
  public function back <A,B,C>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>):OfOf<Cat,A, C> return dot(g,f);
  
}
