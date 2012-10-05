package hots.instances;

import hots.classes.Num;
import hots.classes.Semigroup;




class IntSumSemigroup implements Semigroup<Int>
{
  
  public function new () {}
  
  public inline function append (a:Int, b:Int):Int 
  {
    return a+b;
  }
}
