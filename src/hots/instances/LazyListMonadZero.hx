package hots.instances;

import hots.classes.Monad;
import hots.classes.MonadZeroAbstract;
import hots.In;
import hots.of.LazyListOf;
import scuts.core.extensions.LazyLists;
import scuts.core.types.LazyList;

using hots.box.LazyListBox;

class LazyListMonadZero extends MonadZeroAbstract<LazyList<In>>
{
  public function new (monad) super(monad)
  
  override public inline function zero <A>():LazyListOf<A> 
  {
    return LazyLists.mkEmpty();
  }
}
