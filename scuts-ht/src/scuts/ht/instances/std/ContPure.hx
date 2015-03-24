package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.core.Conts;



class ContPure<R> implements Pure<Cont<R,_>>
{
  public function new () {}

  public function pure<B>(b:B):Cont<R,B>
  {
    return Conts.pure(b);
  }
}
