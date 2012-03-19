package hots.instances;


import hots.classes.PointedAbstract;
import hots.In;

import scuts.core.types.Option;

using hots.macros.Box;

class ArrayOfPointed extends PointedAbstract<Array<In>>
{
  public function new () super(ArrayOfFunctor.get())
  
  override public function pure<B>(b:B):ArrayOf<B> 
  {
    return [b].box();
  }
}
