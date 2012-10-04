package hots.instances;

import hots.classes.MonoidAbstract;
import hots.classes.Num;
import hots.classes.SemigroupAbstract;



class IntSumSemigroup extends SemigroupAbstract<Int>
{
  var intNum:IntNum;
  
  public function new (intNum:IntNum) 
  {
    this.intNum = intNum;
  }
  
  override public inline function append (a:Int, b:Int):Int 
  {
    return intNum.plus(a,b);
  }
}
