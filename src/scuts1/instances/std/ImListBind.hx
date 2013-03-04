package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.core.In;
import scuts1.instances.std.ImListOf;
import scuts.ds.ImLists;



class ImListBind implements Bind<ImList<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:ImListOf<A>, f: A->ImListOf<B>):ImListOf<B> 
  {
    return ImLists.flatMap(x, f);
  }
}
