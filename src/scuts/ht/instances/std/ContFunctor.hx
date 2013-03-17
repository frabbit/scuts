package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.instances.std.ContOf;
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