package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.instances.std.ImListOf;
import scuts.ds.ImLists;



class ImListBind implements Bind<ImList<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:ImListOf<A>, f: A->ImListOf<B>):ImListOf<B> 
  {
    return ImLists.flatMap(x, f);
  }
}
