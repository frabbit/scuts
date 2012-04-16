package hots.instances;
import hots.box.FunctionBox;
import hots.classes.CategoryAbstract;
import hots.In;

using scuts.core.extensions.Functions;

private typedef B = FunctionBox;

class FunctionCategory extends CategoryAbstract<In->In>
{

  public function new() {}
  
  override public function id <A>(a:A):FunctionOf<A, A> {
    return B.asArrow(function (a) return a);
  }
  /**
   * aka (.)
   */
  override public function dot <A,B,C>(f:FunctionOf<B, C>, g:FunctionOf<A, B>):FunctionOf<A, C> {
    var f1 = B.runArrow(f);
    var g1 = B.runArrow(g);
    return B.asArrow(f1.compose(g1));
  }
  
}
