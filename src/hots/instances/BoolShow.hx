package hots.instances;
import hots.classes.Show;


class BoolShow implements Show<Bool> 
{
  public function new () {}

  public inline function show (v:Bool):String 
  {
    return Std.string(v);
  }
}
