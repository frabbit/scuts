package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.instances.std.OptionOf;
import scuts.core.Options;




class OptionBind implements Bind<Option<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:OptionOf<A>, f: A->OptionOf<B>):OptionOf<B> 
  {
    return Options.flatMap(x, f);
  }
}