package hots.instances;

import hots.classes.Functor;
import hots.In;
import hots.Of;
import hots.of.PromiseOf;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;


class PromiseFunctor implements Functor<Promise<In>>
{
  public function new () {}
  
  public function map<A,B>(of:PromiseOf<A>, f:A->B):PromiseOf<B> 
  {
    return Promises.map(of, f);
  }
}
