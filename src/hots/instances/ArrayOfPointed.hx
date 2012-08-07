package hots.instances;

import hots.instances.ArrayOfFunctor;

import hots.classes.PointedAbstract;
import hots.In;

import scuts.core.types.Option;

using hots.box.ArrayBox;

class ArrayOfPointed extends PointedAbstract<Array<In>>
{
  public function new () super(ArrayOfFunctor.get())
  
  override public function pure<B>(b:B):ArrayOf<B> 
  {
    return [b].box();
  }
}
