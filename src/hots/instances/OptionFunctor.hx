package hots.instances;

import hots.classes.Functor;
import hots.In;
import hots.of.OptionOf;
import scuts.core.Options;
import scuts.core.Option;


class OptionFunctor implements Functor<Option<In>>
{
  public function new () {}
  
  public function map<A,B>(x:OptionOf<A>, f:A->B):OptionOf<B> {
    return Options.map(x, f);
  }
}
