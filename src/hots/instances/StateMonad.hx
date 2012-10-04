package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import hots.of.StateOf;
import scuts.core.extensions.States;
import scuts.core.types.State;

using hots.box.StateBox;

class StateMonad<S> extends MonadAbstract<State<S,In>>
{
  public function new (app) super(app)
  
  override public function flatMap<A,B>(x:StateOf<S,A>, f: A->StateOf<S,B>):StateOf<S,B> 
  {
    return States.flatMap(x, f);
  }
}
