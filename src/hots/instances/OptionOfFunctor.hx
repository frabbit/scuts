package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import scuts.core.extensions.OptionExt;
import scuts.core.types.Option;

using hots.macros.Box;

class OptionOfFunctor extends FunctorAbstract<Option<In>>
{
  public function new () {}
  
  override public function map<A,B>(f:A->B, val:OptionOf<A>):OptionOf<B> {
    return OptionExt.map(val.unbox(), f).box();
  }
}
