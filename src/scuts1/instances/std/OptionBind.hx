package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.core.In;
import scuts1.instances.std.OptionOf;
import scuts.core.Options;




class OptionBind implements Bind<Option<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:OptionOf<A>, f: A->OptionOf<B>):OptionOf<B> 
  {
    return Options.flatMap(x, f);
  }
}