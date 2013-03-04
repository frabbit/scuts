package scuts1.instances.std;
import scuts1.instances.std.ArrayTOf;


import scuts1.core.In;
import scuts1.core.Of;
import scuts.core.Arrays;
import scuts1.classes.Functor;






class ArrayTFunctor<M> implements Functor<Of<M,Array<In>>> 
{
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:ArrayTOf<M, A>,f:A->B):ArrayTOf<M, B> 
  {

    return functorM.map(v, Arrays.map.bind(_,f));
  }
}
