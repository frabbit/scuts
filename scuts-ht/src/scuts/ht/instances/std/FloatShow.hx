package scuts.ht.instances.std;
import scuts.ht.classes.Show;


class FloatShow implements Show<Float> 
{
  public function new () {}
  
  public inline function show (v:Float):String 
  {
    return Std.string(v);
  }
}
