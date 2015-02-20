package scuts.ht.instances.std;

import scuts.ht.classes.Pure;


import scuts.core.Options;


class ArrayPure implements Pure<Array<In>>
{
  public function new () {}

  public function pure<B>(b:B):Array<B>
  {
    return [b];
  }
}
