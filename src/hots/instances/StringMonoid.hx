package hots.instances;


import hots.classes.MonoidAbstract;

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

//typedef StringMonoid = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(StringMonoidImpl)]>;