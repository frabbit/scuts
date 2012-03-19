package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;


class BoolShow extends ShowAbstract<Bool> 
{
  public function new () {}

  override public inline function show (v:Bool):String {
    return Std.string(v);
  }
}
