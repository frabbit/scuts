package hots.instances;

import hots.classes.Bind;
import hots.In;
import hots.of.StateOf;
import scuts.core.States;
import scuts.core.State;

using hots.box.StateBox;

class StateBind<S> implements Bind<State<S,In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:StateOf<S,A>, f: A->StateOf<S,B>):StateOf<S,B> 
  {
    return States.flatMap(x, f);
  }
}
