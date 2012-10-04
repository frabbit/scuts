package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import hots.of.LazyListOf;
import scuts.core.extensions.LazyLists;
import scuts.core.types.LazyList;



class LazyListMonad extends MonadAbstract<LazyList<In>>
{
  public function new (app) super(app)
  
  override public function flatMap<A,B>(v:LazyListOf<A>, f: A->LazyListOf<B>):LazyListOf<B> 
  {
    return LazyLists.flatMap(v, f);
  }
}
