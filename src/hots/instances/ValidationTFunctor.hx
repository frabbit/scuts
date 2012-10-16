package hots.instances;

import hots.of.ValidationTOf;
import scuts.core.Validations;
import scuts.core.Validation;
import hots.classes.Functor;
import hots.In;
import hots.Of;

import scuts.core.Option;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

class ValidationTFunctor<M, F> implements Functor<Of<M, Validation<F, In>>> 
{
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(fa:ValidationTOf<M, F, A>, f:A->B):ValidationTOf<M, F, B> 
  {
    function mapInner (x:Validation<F,A>) return Validations.map(x, f);
    
    return functorM.map(fa.runT(), mapInner).intoT();
  }
}
