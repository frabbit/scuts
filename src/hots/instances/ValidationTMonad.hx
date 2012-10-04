package hots.instances;

import hots.In;
import hots.Of;
import hots.of.ValidationTOf;
import scuts.core.types.Validation;
import hots.classes.Monad;
import hots.classes.MonadAbstract;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;


class ValidationTMonad<M,F> extends MonadAbstract<Of<M, Validation<F,In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>, app) {
    super(app);
    this.base = base;
    
  }
  
  override public function flatMap<A,B>(val:ValidationTOf<M,F,A>, f: A->ValidationTOf<M,F,B>):ValidationTOf<M, F,B> 
  {
    function f1 (a) return switch (a) 
    {
      case Success(v): f(v).runT();
      case Failure(f): base.pure(Failure(f));
    }
    
    return base.flatMap(val.runT(), f1).intoT();
  }
  
}

