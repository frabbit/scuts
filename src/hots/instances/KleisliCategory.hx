package hots.instances;


import hots.classes.Category;
import hots.classes.CategoryAbstract;
import hots.classes.Monad;
import hots.In;
import hots.Of;
import hots.of.KleisliOf;

using hots.box.KleisliBox;

class KleisliCategory<M> extends CategoryAbstract<In->Of<M,In>> 
{
  private var m:Monad<M>;
  
  public function new (m:Monad<M>) 
  {
    this.m = m;
  }
  
  override public function id <A>(a:A):KleisliOf<M, A, A> 
  {
    return (function (a) return m.pure(a));
  }
  /**
   * aka (.)
   */
  override public function dot <A,B,C>(f:KleisliOf<M, B, C>, g:KleisliOf<M, A, B>):KleisliOf<M, A, C> 
  {
    var f1 = f.unbox(); // b -> m c
    var g1 = g.unbox(); // a -> m b
    
    // h :: a -> m c
    var h = function (a:A) {
      var c = g1(a); // m b
      return m.flatMap(c, f1); // m c
    }
    return h;
  }
}
