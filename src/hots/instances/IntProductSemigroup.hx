package hots.instances;

import hots.classes.Semigroup;


class IntProductSemigroup implements Semigroup<Int>
{
  public function new () {}
  
  public inline function append (a:Int, b:Int):Int return a * b
  
}
