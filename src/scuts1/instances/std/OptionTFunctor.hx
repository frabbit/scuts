package scuts1.instances.std;

import scuts1.classes.Functor;

import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.OptionTOf;
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
