package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.instances.std.StateOf;
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