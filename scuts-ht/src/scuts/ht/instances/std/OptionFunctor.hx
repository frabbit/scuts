package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.core.Options;


class OptionFunctor implements Functor<Option<In>>
{
  public function new () {}

  public function map<A,B>(x:Option<A>, f:A->B):Option<B> {
    return Options.map(x, f);
  }
}
