package scuts1.instances.std;

import scuts1.classes.Functor;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.PromiseOf;
import scuts.core.Promises;


class PromiseFunctor implements Functor<Promise<In>>
{
  public function new () {}
  
  public function map<A,B>(of:PromiseOf<A>, f:A->B):PromiseOf<B> 
  {
    return Promises.map(of, f);
  }
}
