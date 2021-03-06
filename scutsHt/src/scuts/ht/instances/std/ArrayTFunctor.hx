package scuts.ht.instances.std;
import scuts.ht.instances.std.ArrayTOf;


import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.core.Arrays;
import scuts.ht.classes.Functor;






class ArrayTFunctor<M> implements Functor<Of<M,Array<In>>> 
{
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:ArrayTOf<M, A>,f:A->B):ArrayTOf<M, B> 
  {
  	var q = v;
  	var z = q.runT();

  	var f = Arrays.map.bind(_,f);
    var x =  functorM.map(z,f);
    return x;
  }
}
