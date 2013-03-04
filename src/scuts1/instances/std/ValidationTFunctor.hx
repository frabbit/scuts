package scuts1.instances.std;

import scuts1.instances.std.ValidationTOf;
import scuts.core.Validations;
import scuts1.classes.Functor;
import scuts1.core.In;
import scuts1.core.Of;

import scuts.core.Options;




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
    
    return functorM.map(fa, mapInner);
  }
}
