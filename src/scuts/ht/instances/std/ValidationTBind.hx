package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.ValidationTOf;
import scuts.core.Validations;
import scuts.ht.classes.Monad;




class ValidationTBind<M,F> implements Bind<Of<M, Validation<F,In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>) {
    this.base = base;
  }
  
  public function flatMap<A,B>(val:ValidationTOf<M,F,A>, f: A->ValidationTOf<M,F,B>):ValidationTOf<M, F,B> 
  {
    function f1 (a) return switch (a) 
    {
      case Success(v): f(v);
      case Failure(f): base.pure(Failure(f));
    }
    
    return base.flatMap(val, f1);
  }
  
}

