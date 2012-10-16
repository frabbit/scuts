package hots.instances;


import hots.classes.Pure;
import hots.In;
import hots.of.StateOf;
import scuts.core.States;
import scuts.core.State;
import scuts.core.Tup2;


class StatePure<S> implements Pure<State<S,In>>
{
  public function new () {}
  
  public function pure<A>(x:A):StateOf<S,A> 
  {
    return States.pure(x);
  }
}