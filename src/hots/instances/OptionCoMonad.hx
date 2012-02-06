package hots.instances;

import hots.classes.CoMonad;
import hots.classes.CoMonadAbstract;
import hots.classes.MonadAbstract;
import hots.classes.MonadZeroAbstract;
import hots.In;
import scuts.core.extensions.OptionExt;
import scuts.core.types.Option;
import hots.classes.Monad;
import scuts.Scuts;

using scuts.core.extensions.OptionExt;
using hots.instances.OptionBox;

class OptionCoMonad {
    
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new OptionCoMonadImpl();
    return instance;
  }
}

private class OptionCoMonadImpl extends CoMonadAbstract<Option<In>>
{
  public function new () super(OptionFunctor.get()
  
  override public function extract <A>(val:OptionOf<A>):A 
  {
    return switch (val.unbox()) {
      case Some(v): v;
      case None: Scuts.error("Cannot extract value from empty Option (None)");
    }
  }
  
  override public inline function extend <A,B>(f:OptionOf<A>, fn:OptionOf<A>->B):OptionOf<B> {
    return ret(fn(f)); 
  }
  
  /*
  
  
  
  
  
  public function orElse <A>(v1:MValOption<A>, v2:MValOption<A>):MValOption<A> {
    return if (v1.unbox().isSome()) v1 else v2;
  }
  
  
  */
  
}