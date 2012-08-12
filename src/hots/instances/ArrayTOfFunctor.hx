package hots.instances;
import hots.classes.FunctorAbstract;


import hots.In;
import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Functor;

using hots.box.ArrayBox;



class ArrayTOfFunctor<M> extends FunctorAbstract<Of<M,Array<In>>> 
{
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  override public function map<A,B>(of:ArrayTOf<M, A>,f:A->B):ArrayTOf<M, B> 
  {
    var mapInner = function (x:Array<A>) return Arrays.map(x,f);
    
    return functorM.map(of.unboxT(), mapInner).boxT();
  }
}
