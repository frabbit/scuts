package hots.instances;

import hots.classes.Bind;
import hots.classes.Functor;
import hots.In;
import hots.of.ContOf;
import scuts.core.Conts;
import scuts.core.Cont;
using scuts.core.Functions;

class ContBind<R> implements Bind<Cont<In, R>>
{
  public function new () {}
  
  public function flatMap<B,C>(x:ContOf<B,R>, f:B->ContOf<C,R>):ContOf<C,R> 
  {
    return Conts.flatMap(x, f);
  }
}