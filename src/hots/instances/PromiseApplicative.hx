package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.of.PromiseOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;


class PromiseApplicative extends ApplicativeAbstract<Promise<In>>
{
  public function new (pure, functor) 
  {
    super(pure, functor);
  }
  
  override public function apply<A,B>(f:PromiseOf<A->B>, x:PromiseOf<A>):PromiseOf<B> 
  {
    return Promises.apply(f,x);
  }

}
