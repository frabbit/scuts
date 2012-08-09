package hots.classes;
import hots.OfOf;

import scuts.Scuts;



interface Category<Cat>
{
  
  
  
  public function id <A>(a:A):OfOf<Cat, A, A>;
  /**
   * aka (.)
   */
  public function dot <A,B,C>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>):OfOf<Cat, A, C>;
  
  /**
   * aka >>>
   */
  public function next <A,B,C>(f:OfOf<Cat, A, B>, g:OfOf<Cat, B, C>):OfOf<Cat,A, C>;
  
  /**
   * aka <<<
   */
  public function back <A,B,C>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>):OfOf<Cat,A, C>;
  
}
