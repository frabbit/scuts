package hots.instances;
import hots.classes.FunctorAbstract;

import hots.In;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

private typedef BT = ArrayTBox;
private typedef B = ArrayBox;

class ArrayOfTFunctorImpl<M> extends FunctorAbstract<Of<M,Array<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  /**
   * @inheritDoc
   */
  override public function map<A,B>(f:A->B, fa:ArrayOfT<M, A>):ArrayOfT<M, B> {
    return BT.box(functorM.map(function (x:Array<A>) {
      return B.unbox(ArrayOfFunctor.get().map(f, B.box(x)));
    },BT.unbox(fa)));
  }
}

typedef ArrayOfTFunctor = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayOfTFunctorImpl)]>;
