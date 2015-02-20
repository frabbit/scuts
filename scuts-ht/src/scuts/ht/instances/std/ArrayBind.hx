package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.core.Arrays;


class ArrayBind implements Bind<Array<In>>
{
  public function new () {}

  public function flatMap<A,B>(x:Array<A>, f: A->Array<B>):Array<B>
  {
    return Arrays.flatMap(x, f);
  }
}
