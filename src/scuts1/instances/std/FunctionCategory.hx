package scuts1.instances.std;

import scuts1.classes.CategoryAbstract;
import scuts1.core.In;
import scuts1.instances.std.FunctionOfOf;

using scuts.core.Functions;



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
