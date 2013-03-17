package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.instances.std.OptionOf;
import scuts.core.Options;


class OptionFunctor implements Functor<Option<In>>
{
  public function new () {}
  
  public function map<A,B>(x:OptionOf<A>, f:A->B):OptionOf<B> {
    return Options.map(x, f);
  }
}
