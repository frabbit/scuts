package hots.instances;

import hots.classes.MonoidAbstract;
import hots.classes.SemigroupAbstract;


class IntProductSemigroup extends SemigroupAbstract<Int>
{
  public function new () {}
  
  override public inline function append (a:Int, b:Int):Int return a * b
  
}
