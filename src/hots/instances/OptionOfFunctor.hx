package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

using hots.box.OptionBox;

class OptionOfFunctor extends FunctorAbstract<Option<In>>
{
  public function new () {}
  
  override public function map<A,B>(of:OptionOf<A>, f:A->B):OptionOf<B> {
    return Options.map(of.unbox(), f).box();
  }
}
