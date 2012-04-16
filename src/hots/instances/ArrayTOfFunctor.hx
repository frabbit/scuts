package hots.instances;
import hots.classes.FunctorAbstract;
import hots.macros.Box;

import hots.In;
import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Functor;



using hots.macros.Box;

class ArrayTOfFunctor<M> extends FunctorAbstract<Of<M,Array<In>>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(of:ArrayTOf<M, A>,f:A->B):ArrayTOf<M, B> {
    return 
      functorM
      .map(
        of.unbox(),
        function (x:Array<A>) 
          return ArrayOfFunctor.get().map(x.box(),f).unbox()
       
      )
      .box();
  }
}
