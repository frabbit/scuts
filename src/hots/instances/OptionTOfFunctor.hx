package hots.instances;

import hots.classes.Functor;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;

import scuts.core.types.Option;

private typedef B = hots.macros.Box;


class OptionTOfFunctor<M> extends FunctorAbstract<Of<M, Option<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(f:A->B, fa:OptionTOf<M, A>):OptionTOf<M, B> 
  {
    return B.box(functorM.map(function (x:Option<A>) {
      return B.unbox(OptionOfFunctor.get().map(f, B.box(x)));
    },B.unbox(fa)));
  }
  
}
