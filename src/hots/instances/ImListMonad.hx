package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import hots.of.ImListOf;
import scuts.core.extensions.ImLists;
import scuts.core.types.ImList;



class ImListMonad extends MonadAbstract<ImList<In>>
{
  public function new (app) super(app)
  
  override public function flatMap<A,B>(x:ImListOf<A>, f: A->ImListOf<B>):ImListOf<B> 
  {
    return ImLists.flatMap(x, f);
  }
}
