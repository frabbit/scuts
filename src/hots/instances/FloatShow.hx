package hots.instances;
import hots.classes.ShowAbstract;


class FloatShow extends ShowAbstract<Float> 
{
  public function new () {}
  
  override public inline function show (v:Float):String {
    return Std.string("float: " + v);
  }
}
