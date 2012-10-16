package hots.instances;

import hots.classes.Bind;
import hots.In;
import hots.Of;
import hots.of.OptionTOf;
import scuts.core.Option;

import hots.classes.Monad;

using hots.ImplicitCasts;
using hots.Identity;

class OptionTBind<M> implements Bind<Of<M, Option<In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>) 
  {
    this.base = base;
  }
  
  public function flatMap<A,B>(val:OptionTOf<M,A>, f: A->OptionTOf<M,B>):OptionTOf<M, B> 
  {
    function f1 (a) return switch (a) 
    {
      case Some(v): f(v).runT();
      case None: base.pure(None);
    }
    return base.flatMap(val.runT(), f1);
  }
}
