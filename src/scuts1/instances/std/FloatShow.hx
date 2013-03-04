package scuts1.instances.std;
import scuts1.classes.Show;


class FloatShow implements Show<Float> 
{
  public function new () {}
  
  public inline function show (v:Float):String 
  {
    return Std.string(v);
  }
}
