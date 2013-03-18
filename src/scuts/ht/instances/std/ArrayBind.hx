package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.instances.std.ArrayOf;
import scuts.core.Arrays;


class ArrayBind implements Bind<Array<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return Arrays.flatMap(x, f);
  }
}
