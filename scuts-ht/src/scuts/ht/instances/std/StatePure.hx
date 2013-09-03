package scuts.ht.instances.std;


import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.instances.std.StateOf;
import scuts.core.States;



class StatePure<S> implements Pure<State<S,In>>
{
  public function new () {}
  
  public function pure<A>(x:A):StateOf<S,A> 
  {
    return States.pure(x);
  }
}