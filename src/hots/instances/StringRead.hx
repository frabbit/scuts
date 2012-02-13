package hots.instances;
import hots.classes.Read;
import hots.classes.ReadAbstract;



class StringReadImpl extends ReadAbstract<String> {
  
  public function new () {}
  
  override public inline function read (v:String):String {
    return v;
  }
}

typedef StringRead = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(StringReadImpl)]>;