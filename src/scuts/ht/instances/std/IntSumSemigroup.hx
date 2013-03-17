package scuts.ht.instances.std;

import scuts.ht.classes.Num;
import scuts.ht.classes.Semigroup;




class IntSumSemigroup implements Semigroup<Int>
{
  
  public function new () {}
  
  public inline function append (a:Int, b:Int):Int 
  {
    return a+b;
  }
}
