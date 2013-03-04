package scuts1.instances.std;

import scuts1.classes.Functor;
import scuts1.core.In;
import scuts1.instances.std.OptionOf;
import scuts.core.Options;


class OptionFunctor implements Functor<Option<In>>
{
  public function new () {}
  
  public function map<A,B>(x:OptionOf<A>, f:A->B):OptionOf<B> {
    return Options.map(x, f);
  }
}
