package hots.instances;
import hots.classes.Enumeration;

class IntEnumerationImpl extends Enumeration<Int>{
  
  public function new () {}
  
  override public inline function toEnum (i:Int):Int {
    return i;
  }
  
  override public inline function fromEnum (i:Int):Int {
    return i;
  }
}

typedef IntEnumeration = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(IntEnumerationImpl)]>;