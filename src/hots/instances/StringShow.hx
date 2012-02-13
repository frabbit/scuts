package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;

class StringShowImpl extends ShowAbstract<String> 
{
  public function new () {}
  
  override public inline function show (v:String):String {
    return v;
  }
}

typedef StringShow = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(StringShowImpl)]>;