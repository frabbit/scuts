package scuts1.instances.std;
import scuts1.classes.Show;


class BoolShow implements Show<Bool> 
{
  public function new () {}

  public inline function show (v:Bool):String 
  {
    return Std.string(v);
  }
}
