package hots.instances;
import hots.box.FunctionBox;
import hots.classes.CategoryAbstract;
import hots.In;
import hots.of.FunctionOfOf;

using scuts.core.extensions.Functions;

using hots.box.FunctionBox;

class FunctionCategory extends CategoryAbstract<In->In>
{

  public function new() {}
  
  override public function id <A>(a:A):FunctionOfOf<A, A> 
  {
    return function (a) return a;
  }
  /**
   * aka (.)
   */
  override public function dot <A,B,C>(f:FunctionOfOf<B, C>, g:FunctionOfOf<A, B>):FunctionOfOf<A, C> 
  {
    return f.compose(g);
  }
  
}
