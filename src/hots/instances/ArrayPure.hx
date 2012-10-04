package hots.instances;

import hots.classes.PureAbstract;
import hots.of.ArrayOf;

import hots.In;

import scuts.core.types.Option;


class ArrayPure extends PureAbstract<Array<In>>
{
  public function new () {}
  
  override public function pure<B>(b:B):ArrayOf<B> 
  {
    return [b];
  }
}
