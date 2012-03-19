package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import scuts.core.extensions.OptionExt;
import scuts.core.types.Option;
import hots.classes.Monad;
import scuts.Scuts;

using scuts.core.extensions.OptionExt;

using hots.macros.Box;


class OptionOfMonad extends MonadAbstract<Option<In>>
{
  public function new () super(OptionOfApplicative.get())
  
  override public function flatMap<A,B>(val:OptionOf<A>, f: A->OptionOf<B>):OptionOf<B> 
  {
    return OptionExt.flatMap(val.unbox(), f.unboxF()).box();
  }
}