package scuts1.instances.std;

import scuts1.classes.Semigroup;


class IntProductSemigroup implements Semigroup<Int>
{
  public function new () {}
  
  public inline function append (a:Int, b:Int):Int return a * b;
  
}
