package scuts.ht.instances.std;

using scuts.ht.instances.std.ValidationT;
import scuts.core.Validations;
import scuts.ht.classes.Functor;

import scuts.core.Options;




class ValidationTFunctor<M, F> implements Functor<ValidationT<M, F, _>>
{

  var functorM:Functor<M>;

  public function new (functorM:Functor<M>)
  {
    this.functorM = functorM;
  }

  public function map<A,B>(fa:ValidationT<M, F, A>, f:A->B):ValidationT<M, F, B>
  {
    function mapInner (x:Validation<F,A>) return Validations.map(x, f);

    return functorM.map(fa.runT(), mapInner).validationT();
  }
}
