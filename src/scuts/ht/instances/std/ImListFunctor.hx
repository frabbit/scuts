package scuts.ht.instances.std;

import scuts.ht.core.In;
import scuts.ht.instances.std.ImListOf;
import scuts.ht.classes.Functor;
import scuts.ds.ImLists;



class ImListFunctor implements Functor<ImList<In>>
{
  public function new () {}
  
  public function map<B,C>(x:ImListOf<B>, f:B->C):ImListOf<C> 
  {
    return ImLists.map(x, f);
  }
}