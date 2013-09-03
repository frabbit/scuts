package scuts.ht.instances.std;

import scuts.ht.instances.std.ValidationTOf;
import scuts.core.Validations;
import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.core.Of;

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
