package scuts.ht.instances.std;

import scuts.ht.classes.Pure;
import scuts.ht.instances.std.ArrayOf;

import scuts.ht.core.In;

import scuts.core.Options;


class ArrayPure implements Pure<Array<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):ArrayOf<B> 
  {
    return [b];
  }
}
