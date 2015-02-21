package scuts.ht.instances.std;

import scuts.ht.classes.Functor;
import scuts.ds.ImLists;



class ImListFunctor implements Functor<ImList<_>>
{
  public function new () {}

  public function map<B,C>(x:ImList<B>, f:B->C):ImList<C>
  {
    return ImLists.map(x, f);
  }
}