package scuts1.instances.std;


import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.instances.std.StateOf;
import scuts.core.States;



class StatePure<S> implements Pure<State<S,In>>
{
  public function new () {}
  
  public function pure<A>(x:A):StateOf<S,A> 
  {
    return States.pure(x);
  }
}