package hots.instances;
import hots.classes.ShowAbstract;


class IntShow extends ShowAbstract<Int> 
{
  public function new () {}
  
  override public inline function show (v:Int):String {
    return Std.string(v);
  }
}
