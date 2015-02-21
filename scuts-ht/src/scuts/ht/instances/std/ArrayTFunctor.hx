package scuts.ht.instances.std;
using scuts.ht.instances.std.ArrayT;

import scuts.core.Arrays;
import scuts.ht.classes.Functor;


class ArrayTFunctor<M> implements Functor<ArrayT<M,_>>
{
  var functorM:Functor<M>;

  public function new (functorM:Functor<M>)
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:ArrayT<M, A>,f:A->B):ArrayT<M, B>
  {
  	var q = v;
  	var z = q.runT();

  	var f = Arrays.map.bind(_,f);
    var x =  functorM.map(z,f);
    return x.arrayT();
  }
}
