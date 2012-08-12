package hots.instances;

import hots.instances.ValidationTOf;
import scuts.core.extensions.Validations;
import scuts.core.types.Validation;
import hots.classes.Functor;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;

import scuts.core.types.Option;

using hots.box.ValidationBox;

class ValidationTOfFunctor<M, F> extends FunctorAbstract<Of<M, Validation<F, In>>> 
{
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(fa:ValidationTOf<M, F, A>, f:A->B):ValidationTOf<M, F, B> 
  {
    function mapInner (x:Validation<F,A>) return Validations.map(x, f);
    
    return functorM.map(fa.unboxT(), mapInner).boxT();
  }
}
