package scuts.ht.instances.std;
import scuts.ht.classes.Functor;
import scuts.ht.instances.std.IoOf;

import scuts.ht.core.In;

using scuts.core.Ios;


class IoFunctor implements Functor<Io<In>>
{
  public function new () {}
  
  public function map<A,B>(x:IoOf<A>, f:A->B):IoOf<B> 
  {
    return Ios.map(x, f);
  }
}


