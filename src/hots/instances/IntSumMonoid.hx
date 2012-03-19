package hots.instances;

import hots.classes.MonoidAbstract;



class IntSumMonoid extends MonoidAbstract<Int>
{
  public function new () {}
  
  override public inline function append (a:Int, b:Int):Int {
    return null;//IntNum.get().plus(a,b);
  }
  override public inline function empty ():Int {
    return 0;
  }
}
