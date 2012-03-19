package hots.instances;
import hots.classes.CategoryAbstract;
import hots.In;

using scuts.core.extensions.Function1Ext;

private typedef B = FunctionBox;

class FunctionCategory extends CategoryAbstract<In->In>
{

  public function new() {}
  
  override public function id <A>(a:A):FunctionOf<A, A> {
    return B.box(function (a) return a);
  }
  /**
   * aka (.)
   */
  override public function dot <A,B,C>(f:FunctionOf<B, C>, g:FunctionOf<A, B>):FunctionOf<A, C> {
    var f1 = B.unbox(f);
    var g1 = B.unbox(g);
    return B.box(f1.compose(g1));
  }
  
}
