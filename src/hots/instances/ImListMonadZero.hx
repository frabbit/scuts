package hots.instances;

import hots.classes.Monad;
import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.of.ImListOf;
import scuts.core.extensions.ImLists;
import scuts.core.types.ImList;




class ImListMonadZero extends MonadZeroAbstract<ImList<In>>
{
  public function new (monad) super(monad)
  
  override public inline function zero <A>():ImListOf<A> 
  {
    return ImLists.mkEmpty();
  }
  
}
