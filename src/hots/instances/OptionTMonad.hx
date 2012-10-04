package hots.instances;

import hots.In;
import hots.Of;
import hots.of.OptionTOf;
import scuts.core.types.Option;

import hots.classes.Monad;
import hots.classes.MonadAbstract;

using hots.ImplicitCasts;
using hots.Identity;

class OptionTMonad<M> extends MonadAbstract<Of<M, Option<In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>, app) {
    super(app);
    this.base = base;
    
  }
  
  override public function flatMap<A,B>(val:OptionTOf<M,A>, f: A->OptionTOf<M,B>):OptionTOf<M, B> 
  {
    function f1 (a) return switch (a) 
    {
      case Some(v): f(v).runT();
      case None: base.pure(None);
    }
    return base.flatMap(val.runT(), f1);
  }
}
