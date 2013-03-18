package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.instances.std.StateOf;
import scuts.core.States;




class StateBind<S> implements Bind<State<S,In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:StateOf<S,A>, f: A->StateOf<S,B>):StateOf<S,B> 
  {
    return States.flatMap(x, f);
  }
}
