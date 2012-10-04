package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import hots.of.PromiseOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;


class PromiseMonad extends MonadAbstract<Promise<In>>
{
  public function new (app) super(app)
  
  override public function flatMap<A,B>(val:PromiseOf<A>, f: A->PromiseOf<B>):PromiseOf<B> 
  {
    return Promises.flatMap(val, f);
  }
}