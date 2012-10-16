package hots.instances;

import hots.classes.Bind;
import hots.In;
import hots.of.ArrayOf;
import scuts.core.Arrays;


class ArrayBind implements Bind<Array<In>>
{
  public function new () {}
  
  public function flatMap<A,B>(x:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return Arrays.flatMap(x, f);
  }
}
