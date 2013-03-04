package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.core.In;
import scuts1.instances.std.ArrayOf;
import scuts.core.Arrays;


class ArrayBind implements Bind<Array<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return Arrays.flatMap(x, f);
  }
}
