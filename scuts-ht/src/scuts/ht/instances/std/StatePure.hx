package scuts.ht.instances.std;


import scuts.ht.classes.Pure;
import scuts.core.States;



class StatePure<S> implements Pure<State<S,_>>
{
  public function new () {}

  public function pure<A>(x:A):State<S,A>
  {
    return States.pure(x);
  }
}