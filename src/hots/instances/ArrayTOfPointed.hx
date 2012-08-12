package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.classes.Pointed;
import hots.classes.PointedAbstract;
import hots.instances.ArrayTOfFunctor;
import hots.In;
import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Functor;


using hots.box.ArrayBox;

class ArrayTOfPointed<M> extends PointedAbstract<Of<M,Array<In>>> 
{
  var pointedM:Pointed<M>;

  public function new (pointedM:Pointed<M>, functor) 
  {
    super(functor);
    this.pointedM = pointedM;
  }

  /**
   * aka return, pure
   */
  override public function pure<A>(x:A):ArrayTOf<M,A> 
  {
    return pointedM.pure([x]).boxT();
  }
  

}
