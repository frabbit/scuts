package hots.instances;

import hots.classes.Apply;
import hots.classes.Pure;
import hots.In;
import hots.of.StateOf;
import scuts.core.State;
import scuts.core.Tup2;

using hots.box.StateBox;


class StateApply<S> implements Apply<State<S,In>>
{
  public function new () {}
  
  public function apply<A,B>(f:StateOf<S,A->B>, x:StateOf<S, A>):StateOf<S,B> 
  {
    return function (s:S) 
    {
      var z1 = f.unbox()(s);
      
      var z2 = x.unbox()(z1._1); 
      
      return Tup2.create(z2._1, z1._2(z2._2));
    }
  }
}