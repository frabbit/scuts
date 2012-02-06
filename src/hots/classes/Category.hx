package hots.classes;
import hots.COf;
import hots.TC;
import scuts.Scuts;



interface Category<Cat> implements TC
{
  public function id <A>(a:A):COf<Cat, A, A>;
  /**
   * aka (.)
   */
  public function dot <A,B,C>(g:COf<Cat, B, C>, f:COf<Cat, A, B>):COf<Cat, A, C>;
  
  /**
   * aka >>>
   */
  public function next <A,B,C>(f:COf<Cat, A, B>, g:COf<Cat, B, C>):COf<Cat,A, C>;
  
  /**
   * aka <<<
   */
  public function back <A,B,C>(g:COf<Cat, B, C>, f:COf<Cat, A, B>):COf<Cat,A, C>;
  
}
