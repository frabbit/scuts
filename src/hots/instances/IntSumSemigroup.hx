package hots.instances;

import hots.classes.MonoidAbstract;
import hots.classes.SemigroupAbstract;



class IntSumSemigroup extends SemigroupAbstract<Int>
{
  public function new () {}
  
  override public inline function append (a:Int, b:Int):Int {
    return IntNum.get().plus(a,b);
  }
}
