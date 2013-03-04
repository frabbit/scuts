package scuts1.instances.std;
import scuts1.classes.Functor;
import scuts1.instances.std.IoOf;
import scuts.core.Ios;
import scuts.core.Io;

import scuts1.core.In;

using scuts.core.Ios;


class IoFunctor implements Functor<Io<In>>
{
  public function new () {}
  
  public function map<A,B>(x:IoOf<A>, f:A->B):IoOf<B> 
  {
    return Ios.map(x, f);
  }
}


