package hots.instances;

import hots.classes.Functor;
import hots.In;
import hots.of.ContOf;
import scuts.core.extensions.Conts;
import scuts.core.types.Cont;
using scuts.core.extensions.Functions;

class ContFunctor<R> implements Functor<Cont<In, R>>
{
  public function new () {}
  
  public function map<B,C>(x:ContOf<B,R>, f:B->C):ContOf<C,R> 
  {
    return Conts.map(x, f);
  }
}