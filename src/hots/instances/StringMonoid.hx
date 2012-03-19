package hots.instances;


import hots.classes.MonoidAbstract;

class StringMonoid extends MonoidAbstract<String>
{
  public function new () {}
  
  override public inline function append (a:String, b:String):String {
    return a + b;
  }
  override public inline function empty ():String {
    return "";
  }
}
