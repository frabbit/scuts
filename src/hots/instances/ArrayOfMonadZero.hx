package hots.instances;

import hots.classes.MonadZeroAbstract;
import hots.In;



using hots.box.ArrayBox;

class ArrayOfMonadZero extends MonadZeroAbstract<Array<In>>
{
  public function new () super(ArrayOfMonad.get())
  
  override public inline function zero <A>():ArrayOf<A> {
    var res:Array<A> = [];
    return res.box();
  }
  
}
