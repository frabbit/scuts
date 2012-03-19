package hots.instances;
import hots.classes.FunctorAbstract;
import hots.macros.Box;

import hots.In;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

private typedef B = Box;

class ArrayTOfFunctor<M> extends FunctorAbstract<Of<M,Array<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(f:A->B, fa:ArrayTOf<M, A>):ArrayTOf<M, B> {
    return B.box(functorM.map(function (x:Array<A>) {
      return B.unbox(ArrayOfFunctor.get().map(f, B.box(x)));
    },B.unbox(fa)));
  }
}
