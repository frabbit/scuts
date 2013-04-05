package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.PromiseOf;
import scuts.core.Promises;


class PromiseFunctor implements Functor<PromiseD<In>>
{
  public function new () {}
  
  public function map<A,B>(of:PromiseOf<A>, f:A->B):PromiseOf<B> 
  {
    return Promises.map(of, f);
  }
}
