package hots.instances;

import hots.classes.Bind;
import hots.In;
import hots.of.OptionOf;
import scuts.core.extensions.Options;
import scuts.core.types.Option;



class OptionBind implements Bind<Option<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:OptionOf<A>, f: A->OptionOf<B>):OptionOf<B> 
  {
    return Options.flatMap(x, f);
  }
}