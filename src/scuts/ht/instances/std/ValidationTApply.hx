package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.classes.Functor;
import scuts.ht.instances.std.ValidationTOf;
import scuts.core.Validations;

import scuts.core.Validations;





class ValidationTApply<M,F> implements Apply<Of<M,Validation<F,In>>> 
{
  
  var funcM:Functor<M>;
  var applyM:Apply<M>;

  public function new (funcM:Functor<M>, applyM:Apply<M>) 
  {
    this.funcM = funcM;
    this.applyM = applyM;
  }

  /**
   * aka <*>
   */
  public function apply<A,B>(f:ValidationTOf<M,F,A->B>, val:ValidationTOf<M,F,A>):ValidationTOf<M,F,B> 
  {
    function mapInner (f:Validation<F, A->B>)
    {
      return function (a:Validation<F, A>) return Validations.zipWith(f,a, function (f1, a1) return f1(a1));
    }
    
    var newF = funcM.map(f.runT(), mapInner);
    
    return applyM.apply(newF, val);
  }

}
