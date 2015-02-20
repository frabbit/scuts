package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.core.States;




class StateBind<S> implements Bind<State<S,In>>
{
  public function new () {}

  public function flatMap<A,B>(x:State<S,A>, f: A->State<S,B>):State<S,B>
  {
    return States.flatMap(x, f);
  }
}
