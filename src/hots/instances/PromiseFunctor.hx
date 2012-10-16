package hots.instances;

import hots.classes.Functor;
import hots.In;
import hots.Of;
import hots.of.PromiseOf;
import scuts.core.Promises;
import scuts.core.Promise;


class PromiseFunctor implements Functor<Promise<In>>
{
  public function new () {}
  
  public function map<A,B>(of:PromiseOf<A>, f:A->B):PromiseOf<B> 
  {
    return Promises.map(of, f);
  }
}
