package hots.instances;

import hots.classes.Functor;
import hots.In;
import hots.instances.Function1Semigroup;
import hots.Of;

import hots.of.FunctionOf;

using hots.box.FunctionBox;

class Function1_2Functor<A> implements Functor<A->In>
{
  public function new () {}
  
  public function map<R, R1>(g:Function1_2Of<A, R>, f:R->R1):Function1_2Of<A,R1>
  {
    var g1:A->R = g;
    return (function (x:A) return f(g1(x)));
  }
}
