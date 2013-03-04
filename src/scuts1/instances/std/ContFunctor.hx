package scuts1.instances.std;

import scuts1.classes.Functor;
import scuts1.core.In;
import scuts1.instances.std.ContOf;
import scuts.core.Conts;
import scuts.core.Cont;
using scuts.core.Functions;

class ContFunctor<R> implements Functor<Cont<In, R>>
{
  public function new () {}
  
  public function map<B,C>(x:ContOf<B,R>, f:B->C):ContOf<C,R> 
  {
    return Conts.map(x, f);
  }
}