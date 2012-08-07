package hots.instances;
import hots.box.ValidationBox;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.classes.Pointed;
import hots.classes.PointedAbstract;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import scuts.core.types.Option;
import scuts.core.types.Validation;

using scuts.core.extensions.Validations;
using hots.box.ValidationBox;


class ValidationTOfPointed<F, M> extends PointedAbstract<Of<M,Validation<F, In>>> 
{
  var pointedM:Pointed<M>;

  public function new (pointedM:Pointed<M>) 
  {
    super(ValidationTOfFunctor.get(pointedM));
    this.pointedM = pointedM;
  }

  /**
   * aka return
   */
  override public function pure<A>(x:A):ValidationTOf<M,F,A> 
  {
    var v : Validation<F,A> = x.toSuccess();
    return pointedM.pure(v).boxT();
  }
  

}
