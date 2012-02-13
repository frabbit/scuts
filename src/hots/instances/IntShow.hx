package hots.instances;
import hots.classes.ShowAbstract;


class IntShowImpl extends ShowAbstract<Int> 
{
  public function new () {}
  
  override public inline function show (v:Int):String {
    return Std.string(v);
  }
}

typedef IntShow = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(IntShowImpl)]>;