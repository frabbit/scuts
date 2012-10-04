package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import hots.of.OptionOf;
import scuts.core.extensions.Options;
import scuts.core.types.Option;


class OptionFunctor extends FunctorAbstract<Option<In>>
{
  public function new () {}
  
  override public function map<A,B>(x:OptionOf<A>, f:A->B):OptionOf<B> {
    return Options.map(x, f);
  }
}
