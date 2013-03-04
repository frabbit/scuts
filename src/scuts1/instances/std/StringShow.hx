package scuts1.instances.std;
import scuts1.classes.Show;

class StringShow implements Show<String> 
{
  public function new () {}
  
  public inline function show (v:String):String {
    return v;
  }
}
