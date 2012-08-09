package hots.instances;

import hots.instances.ArrayOfPointed;
import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.classes.Applicative;
import hots.Objects;
import scuts.core.types.Option;


using hots.box.ArrayBox;

class ArrayOfApplicative extends ApplicativeAbstract<Array<In>>
{
  public function new (pointed) super(pointed)
  
  override public function apply<B,C>(f:ArrayOf<B->C>, v:ArrayOf<B>):ArrayOf<C> 
  {
    var res = [];
    for (func in f.unbox()) 
    {
      for (e in v.unbox()) 
      {
        res.push(func(e));
      }
    }
    return res.box();
  }
}
