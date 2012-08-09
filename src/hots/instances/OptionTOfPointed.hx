package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.classes.Pointed;
import hots.classes.PointedAbstract;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import scuts.core.types.Option;


using hots.box.OptionBox;



class OptionTOfPointed<M> extends PointedAbstract<OfT<M,Option<In>>> {
  
  var pointedM:Pointed<M>;

  public function new (pointedM:Pointed<M>, functor) 
  {
    super(functor);
    this.pointedM = pointedM;
  }

  /**
   * aka return
   */
  override public function pure<A>(x:A):OptionTOf<M,A> {
    return pointedM.pure(Some(x)).boxT();
  }
  

}
