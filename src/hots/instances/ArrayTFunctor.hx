package hots.instances;
import hots.of.ArrayTOf;


import hots.In;
import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Functor;


using hots.ImplicitCasts;
using hots.Identity;

class ArrayTFunctor<M> implements Functor<Of<M,Array<In>>> 
{
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:ArrayTOf<M, A>,f:A->B):ArrayTOf<M, B> 
  {
    var f1 = function (x) return Arrays.map(x,f);
    
    return functorM.map(v.runT(), f1).intoT();
  }
}
