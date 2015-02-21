package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.Functor;
import scuts.core.Validations;

import scuts.core.Validations;
using scuts.ht.instances.std.ValidationT;
import scuts.ht.classes.ApplyAbstract;



class ValidationTApply<M,F> extends ApplyAbstract<ValidationT<M, F, _>>
{

  var funcM:Functor<M>;
  var applyM:Apply<M>;

  public function new (funcM:Functor<M>, applyM:Apply<M>, func)
  {
    super(func);
    this.funcM = funcM;
    this.applyM = applyM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(val:ValidationT<M,F,A>, f:ValidationT<M,F,A->B>):ValidationT<M,F,B>
  {
    function mapInner (f:Validation<F, A->B>)
    {
      return function (a:Validation<F, A>) return Validations.zipWith(f,a, function (f1, a1) return f1(a1));
    }

    var newF = funcM.map(f.runT(), mapInner);

    return applyM.apply(val.runT(), newF).validationT();
  }

}
