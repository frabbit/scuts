package hots.instances;

import hots.classes.Functor;
import hots.In;
import hots.of.StateOf;
import scuts.core.extensions.States;
import scuts.core.types.State;
import scuts.core.types.Tup2;

using hots.box.StateBox;


class StateFunctor<S> implements Functor<State<S,In>>
{
  public function new () {}
  
  public function map<A,B>(x:StateOf<S,A>, f:A->B):StateOf<S,B> 
  {
    return States.map(x,f);
  }
}