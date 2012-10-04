package hots.instances;

import hots.classes.FunctorAbstract;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.In;
import hots.instances.Function1Semigroup;
import hots.Of;

import hots.of.FunctionOf;

using hots.box.FunctionBox;

class Function1_2Functor<A> extends FunctorAbstract<A->In>
{
  public function new () {}
  
  override public function map<R, R1>(g:Function1_2Of<A, R>, f:R->R1):Function1_2Of<A,R1>
  {
    var g1:A->R = g;
    return (function (x:A) return f(g1(x)));
  }
}
