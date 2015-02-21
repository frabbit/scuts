package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.core.Options;




class OptionBind implements Bind<Option<_>>
{
  public function new () {}

  public function flatMap<A,B>(x:Option<A>, f: A->Option<B>):Option<B>
  {
    return Options.flatMap(x, f);
  }
}