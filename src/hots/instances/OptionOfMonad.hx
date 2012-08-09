package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import hots.Objects;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

using hots.box.OptionBox;


class OptionOfMonad extends MonadAbstract<Option<In>>
{
  public function new (app) super(app)
  
  override public function flatMap<A,B>(val:OptionOf<A>, f: A->OptionOf<B>):OptionOf<B> 
  {
    return Options.flatMap(val.unbox(), f.unboxF()).box();
  }
}