package scuts.ht.instances.std;

import scuts.ht.classes.Functor;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.OptionTOf;
import scuts.core.Options;




class OptionTFunctor<M> implements Functor<Of<M, Option<In>>> 
{
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:OptionTOf<M, A>, f:A->B):OptionTOf<M, B> 
  {
    return functorM.map(v,  Options.map.bind(_,f));
  }
}
