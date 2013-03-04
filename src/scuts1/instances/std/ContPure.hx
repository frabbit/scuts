package scuts1.instances.std;

import scuts1.classes.Pure;
import scuts1.instances.std.ContOf;
import scuts.core.Conts;
import scuts.core.Cont;
import scuts1.core.In;


class ContPure<R> implements Pure<Cont<In,R>>
{
  public function new () {}
  
  public function pure<B>(b:B):ContOf<B,R> 
  {
    return Conts.pure(b);
  }
}
