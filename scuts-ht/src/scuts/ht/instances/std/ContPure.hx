package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ht.instances.std.ContOf;
import scuts.core.Conts;

import scuts.ht.core._;


class ContPure<R> implements Pure<Cont<_,R>>
{
  public function new () {}

  public function pure<B>(b:B):ContOf<B,R>
  {
    return Conts.pure(b);
  }
}
