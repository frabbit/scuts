package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import scuts.core.extensions.OptionExt;
import scuts.core.types.Option;
import hots.classes.Monad;
import scuts.Scuts;

using scuts.core.extensions.OptionExt;
using hots.instances.OptionBox;


class OptionOfMonadImpl extends MonadAbstract<Option<In>>
{
  public function new () super(OptionOfApplicative.get())
  
  override public function flatMap<A,B>(val:OptionOf<A>, f: A->OptionOf<B>):OptionOf<B> 
  {
    return OptionExt.flatMap(val.unbox(), f.unboxF()).box();
  }
  
  /*
  public function extract <A>(val:MValOption<A>):A 
  {
    return switch (val.unbox()) {
      case Some(v): v;
      case None: Scuts.error("Cannot extract value from empty Option (None)");
    }
  }
  
  
  
  public function orElse <A>(v1:MValOption<A>, v2:MValOption<A>):MValOption<A> {
    return if (v1.unbox().isSome()) v1 else v2;
  }
  
  public function extend <A,B>(f:MValOption<A>, fn:MValOption<A>->B):MValOption<B> {
    var b = fn(f);
    return ret(b); 
  }
  */
  
}
typedef OptionOfMonad = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionOfMonadImpl)]>;
