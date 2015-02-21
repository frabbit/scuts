package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.core.Conts;

using scuts.core.Functions;

class ContFunctor<R> implements Functor<Cont<R, _>>
{
  public function new () {}

  public function map<B,C>(x:Cont<R,B>, f:B->C):Cont<R,C>
  {
    return Conts.map(x, f);
  }
}