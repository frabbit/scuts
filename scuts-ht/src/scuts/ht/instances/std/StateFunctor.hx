package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.core.States;
import scuts.core.Tuples;




class StateFunctor<S> implements Functor<State<S,_>>
{
  public function new () {}

  public function map<A,B>(x:State<S,A>, f:A->B):State<S,B>
  {
    return States.map(x,f);
  }
}