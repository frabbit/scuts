package scuts1.instances.std;

import scuts1.classes.Functor;
import scuts1.core.In;
import scuts1.instances.std.StateOf;
import scuts.core.States;
import scuts.core.Tuples;




class StateFunctor<S> implements Functor<State<S,In>>
{
  public function new () {}
  
  public function map<A,B>(x:StateOf<S,A>, f:A->B):StateOf<S,B> 
  {
    return States.map(x,f);
  }
}