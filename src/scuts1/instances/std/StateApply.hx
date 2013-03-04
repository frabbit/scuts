package scuts1.instances.std;

import scuts1.classes.Apply;
import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.instances.std.StateOf;
import scuts.core.States;
import scuts.core.Tuples;




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