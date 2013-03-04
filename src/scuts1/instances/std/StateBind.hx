package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.core.In;
import scuts1.instances.std.StateOf;
import scuts.core.States;




class StateBind<S> implements Bind<State<S,In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:StateOf<S,A>, f: A->StateOf<S,B>):StateOf<S,B> 
  {
    return States.flatMap(x, f);
  }
}
