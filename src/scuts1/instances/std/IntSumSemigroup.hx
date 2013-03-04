package scuts1.instances.std;

import scuts1.classes.Num;
import scuts1.classes.Semigroup;




class IntSumSemigroup implements Semigroup<Int>
{
  
  public function new () {}
  
  public inline function append (a:Int, b:Int):Int 
  {
    return a+b;
  }
}
