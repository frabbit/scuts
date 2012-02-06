package hots.instances;


import hots.classes.MonoidAbstract;

class StringMonoid
{
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new StringMonoidImpl();
    return instance;
  }
}

class StringMonoidImpl extends MonoidAbstract<String>
{
  public function new () {}
  
  override public inline function append (a:String, b:String):String {
    return a + b;
  }
  override public inline function empty ():String {
    return "";
  }
}