package hots.instances;

import hots.classes.Monoid;

class MonoidIntProduct
{
  static var instance:MonoidIntProductImpl;
  
  public static function get ():Monoid<Int>
  {
    if (instance == null) instance = new MonoidIntProductImpl();
    return cast instance;
  }
}

private class MonoidIntProductImpl extends MonoidDefault<Int>
{
  public function new () {}
  
  override public inline function append (a:Int, b:Int):Int {
    return a * b;
  }
  override public inline function empty ():Int {
    return 1;
  }
}