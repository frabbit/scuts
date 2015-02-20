package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.classes.Pure;
import scuts.core.States;
import scuts.core.Tuples;




class StateApply<S> extends ApplyAbstract<State<S,In>>
{
  public function new (func) super(func);

  override public function apply<A,B>(x:State<S, A>, f:State<S,A->B>):State<S,B>
  {
    return new State(function (s:S)
    {
      var z1 = f(s);

      var z2 = x(z1._1);

      return Tup2.create(z2._1, z1._2(z2._2));
    });
  }
}