package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;

class IntSumMonoid
{
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new IntSumMonoidImpl();
    return instance;
  }
}

private class IntSumMonoidImpl extends MonoidAbstract<Int>
{
  public function new () {}
  
  override public inline function append (a:Int, b:Int):Int {
    return a + b;
  }
  override public inline function empty ():Int {
    return 0;
  }
}