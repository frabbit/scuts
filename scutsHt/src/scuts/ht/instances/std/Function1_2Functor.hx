package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.instances.std.Function1Semigroup;
import scuts.ht.core.Of;

import scuts.ht.instances.std.FunctionOf;



class Function1_2Functor<A> implements Functor<A->In>
{
  public function new () {}
  
  public function map<R, R1>(g:Function1_2Of<A, R>, f:R->R1):Function1_2Of<A,R1>
  {
    var g1:A->R = g;
    return (function (x:A) return f(g1(x)));
  }
}
