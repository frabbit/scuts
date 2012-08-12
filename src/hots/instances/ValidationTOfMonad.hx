package hots.instances;

import hots.In;
import hots.Objects;
import hots.Of;
import scuts.core.types.Option;
import scuts.core.types.Validation;
using scuts.core.extensions.Options;
import hots.classes.Monad;
import hots.classes.MonadAbstract;



using hots.box.ValidationBox;

class ValidationTOfMonad<M,F> extends MonadAbstract<Of<M, Validation<F,In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>, app) {
    super(app);
    this.base = base;
    
  }
  
  override public function flatMap<A,B>(val:ValidationTOf<M,F,A>, f: A->ValidationTOf<M,F,B>):ValidationTOf<M, F,B> 
  {
    return base.flatMap(val.unboxT(), function (a)
    {
      return switch (a) 
      {
        case Success(v): f(v).unboxT();
        case Failure(f): base.pure(Failure(f));
      }
    }).boxT();
  }
  
}

