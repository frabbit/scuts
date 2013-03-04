package scuts1.instances.std;

import scuts1.core.In;
import scuts1.instances.std.ImListOf;
import scuts1.classes.Functor;
import scuts.ds.ImLists;



class ImListFunctor implements Functor<ImList<In>>
{
  public function new () {}
  
  public function map<B,C>(x:ImListOf<B>, f:B->C):ImListOf<C> 
  {
    return ImLists.map(x, f);
  }
}