package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.of.PromiseOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;

using hots.ImplicitCasts;
using hots.Hots;

class PromiseFunctor extends FunctorAbstract<Promise<In>>
{
  public function new () {}
  
  override public function map<A,B>(of:PromiseOf<A>, f:A->B):PromiseOf<B> 
  {
    return Promises.map(of, f);
  }
}
