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

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

private typedef B = OptionTBox;



class OptionTOfPointedImpl<M> extends PointedAbstract<Of<M,Option<In>>> {
  
  var pointedM:Pointed<M>;

  public function new (pointedM:Applicative<M>) 
  {
    super(OptionTOfFunctor.get(pointedM));
    this.pointedM = pointedM;
  }

  /**
   * aka return
   */
  override public function pure<A>(x:A):OptionTOf<M,A> {
    return B.box(pointedM.pure(Some(x)));
  }
  

}

typedef OptionTOfPointed = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionTOfPointedImpl)]>;