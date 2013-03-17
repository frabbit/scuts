package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ht.instances.std.ContOf;
import scuts.core.Conts;
import scuts.core.Cont;
import scuts.ht.core.In;


class ContPure<R> implements Pure<Cont<In,R>>
{
  public function new () {}
  
  public function pure<B>(b:B):ContOf<B,R> 
  {
    return Conts.pure(b);
  }
}
