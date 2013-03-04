package scuts1.instances.std;

import scuts1.classes.Pure;
import scuts1.instances.std.ArrayOf;

import scuts1.core.In;

import scuts.core.Options;


class ArrayPure implements Pure<Array<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):ArrayOf<B> 
  {
    return [b];
  }
}
