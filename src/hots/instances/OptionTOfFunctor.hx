package hots.instances;

import hots.classes.Functor;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;

import scuts.core.types.Option;

private typedef B = OptionBox;
private typedef BT = OptionTBox;


class OptionTOfFunctorImpl<M> extends FunctorAbstract<Of<M, Option<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(f:A->B, fa:OptionTOf<M, A>):OptionTOf<M, B> {
    
    return BT.box(functorM.map(function (x) {
      return B.unbox(OptionOfFunctor.get().map(f, B.box(x)));
    },BT.unbox(fa)));
  }
}

typedef OptionTOfFunctor = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionTOfFunctorImpl)]>;