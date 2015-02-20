package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
using scuts.ht.instances.std.ValidationT;
import scuts.core.Validations;
import scuts.ht.classes.Monad;




class ValidationTBind<M,F> implements Bind<ValidationT<M,F,In>> {

  var base:Monad<M>;

  public function new (base:Monad<M>) {
    this.base = base;
  }

  public function flatMap<A,B>(val:ValidationT<M,F,A>, f: A->ValidationT<M,F,B>):ValidationT<M, F,B>
  {
    function f1 (a):M<Validation<F,B>> return switch (a)
    {
      case Success(v): f(v).runT();
      case Failure(f): base.pure(Failure(f));
    }

    return base.flatMap(val.runT(), f1).validationT();
  }

}

