package hots.instances;

import hots.classes.Functor;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import scuts.core.extensions.Options;

import scuts.core.types.Option;

private typedef B = hots.box.OptionBox;

class OptionTOfFunctor<M> extends FunctorAbstract<OfT<M, Option<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(fa:OptionTOf<M, A>, f:A->B):OptionTOf<M, B> 
  {
    function mapInner (x:Option<A>) return Options.map(x, f);

    return B.boxT(functorM.map(B.unboxT(fa), mapInner));
  }
}
