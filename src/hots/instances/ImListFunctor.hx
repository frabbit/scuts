package hots.instances;

import hots.In;
import hots.of.ImListOf;
import hots.classes.Functor;
import scuts.core.extensions.ImLists;
import scuts.core.types.ImList;



class ImListFunctor implements Functor<ImList<In>>
{
  public function new () {}
  
  public function map<B,C>(x:ImListOf<B>, f:B->C):ImListOf<C> 
  {
    return ImLists.map(x, f);
  }
}