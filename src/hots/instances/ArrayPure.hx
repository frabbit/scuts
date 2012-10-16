package hots.instances;

import hots.classes.Pure;
import hots.of.ArrayOf;

import hots.In;

import scuts.core.Option;


class ArrayPure implements Pure<Array<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):ArrayOf<B> 
  {
    return [b];
  }
}
