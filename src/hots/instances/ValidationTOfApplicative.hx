package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.classes.Functor;

import scuts.core.types.Validation;




using hots.box.ValidationBox;



class ValidationTOfApplicative<M,F> extends ApplicativeAbstract<Of<M,Validation<F,In>>> 
{
  
  var applicativeM:Applicative<M>;

  public function new (applicativeM:Applicative<M>, pointed) 
  {
    super(pointed);
    this.applicativeM = applicativeM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(f:ValidationTOf<M,F,A->B>, val:ValidationTOf<M,F,A>):ValidationTOf<M,F,B> 
  {
    function mapInner (f:Validation<F, A->B>)
    {
      return function (a:Validation<F, A>) return switch (f) 
      {
        case Success(v):
          switch (a) {
            case Success(v2): Success(v(v2));
            case Failure(f): Failure(f);
          }
        case Failure(f): Failure(f);
      }
    }
    
    var newF = applicativeM.map(f.unboxT(), mapInner);
    
    return applicativeM.apply(newF, val.unboxT()).boxT();
  }

}
