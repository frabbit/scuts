package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ds.ImLists;


using scuts.ht.core.Ht;

class ImListApply extends ApplyAbstract<ImList<_>>
{
  public function new (func) {
  	super(func);
  }

  override public function apply<B,C>( v:ImList<B>, f:ImList<B->C>):ImList<C>
  {
    return ImLists.flatMap(f, function (f1)
    {
      return ImLists.map(v, function (x) return f1(x));
    });
  }
}
