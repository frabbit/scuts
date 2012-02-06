package hots.classes;
import hots.COf;

import scuts.Scuts;



@:tcAbstract class CategoryAbstract<Cat> implements Category<Cat>
{
  public function id <A>(a:A):COf<Cat, A, A> return Scuts.abstractMethod()
  /**
   * aka (.)
   */
  public function dot <A,B,C>(g:COf<Cat, B, C>, f:COf<Cat, A, B>):COf<Cat, A, C> return Scuts.abstractMethod()
  
  /**
   * aka >>>
   */
  public function next <A,B,C>(f:COf<Cat, A, B>, g:COf<Cat, B, C>):COf<Cat,A, C> return dot(g,f)
  
  /**
   * aka <<<
   */
  public function back <A,B,C>(g:COf<Cat, B, C>, f:COf<Cat, A, B>):COf<Cat,A, C> return dot(g,f)
  
}
