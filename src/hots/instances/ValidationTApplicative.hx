package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import hots.of.ValidationTOf;
import scuts.core.extensions.Validations;

import scuts.core.types.Validation;


using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;


class ValidationTApplicative<M,F> extends ApplicativeAbstract<Of<M,Validation<F,In>>> 
{
  
  var applicativeM:Applicative<M>;

  public function new (applicativeM:Applicative<M>, pure, functor) 
  {
    super(pure, functor);
    this.applicativeM = applicativeM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(f:ValidationTOf<M,F,A->B>, val:ValidationTOf<M,F,A>):ValidationTOf<M,F,B> 
  {
    function mapInner (f:Validation<F, A->B>)
    {
      return function (a:Validation<F, A>) return Validations.zipWith(f,a, function (f1, a1) return f1(a1));
    }
    
    var newF = applicativeM.map(f.runT(), mapInner);
    
    return applicativeM.apply(newF, val.runT()).intoT();
  }

}
