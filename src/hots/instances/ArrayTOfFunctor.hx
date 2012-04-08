package hots.instances;
import hots.classes.FunctorAbstract;
import hots.macros.Box;

import hots.In;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;



using hots.macros.Box;

class ArrayTOfFunctor<M> extends FunctorAbstract<Of<M,Array<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(f:A->B, fa:ArrayTOf<M, A>):ArrayTOf<M, B> {
    return 
      functorM
      .map(
        function (x:Array<A>) 
          return ArrayOfFunctor.get().map(f, x.box()).unbox(), 
        fa.unbox()
      )
      .box();
  }
}
