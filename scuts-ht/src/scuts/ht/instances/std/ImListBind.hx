package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ds.ImLists;



class ImListBind implements Bind<ImList<In>>
{
  public function new () {}

  public function flatMap<A,B>(x:ImList<A>, f: A->ImList<B>):ImList<B>
  {
    return ImLists.flatMap(x, f);
  }
}
