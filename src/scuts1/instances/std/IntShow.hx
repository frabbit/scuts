package scuts1.instances.std;
import scuts1.classes.Show;


class IntShow implements Show<Int> 
{
  public function new () {}
  
  public inline function show (v:Int):String {
    return Std.string(v);
  }
}
