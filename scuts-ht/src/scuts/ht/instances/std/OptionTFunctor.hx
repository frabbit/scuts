package scuts.ht.instances.std;

import scuts.ht.classes.Functor;

using scuts.ht.instances.std.OptionT;
import scuts.core.Options;




class OptionTFunctor<M> implements Functor<OptionT<M,In>>
{

  var functorM:Functor<M>;

  public function new (functorM:Functor<M>)
  {
    this.functorM = functorM;
  }

  public function map<A,B>(v:OptionT<M, A>, f:A->B):OptionT<M, B>
  {
    return functorM.map(v.runT(),  Options.map.bind(_,f)).optionT();
  }
}
