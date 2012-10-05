package hots.instances;
import hots.classes.Show;

class StringShow implements Show<String> 
{
  public function new () {}
  
  public inline function show (v:String):String {
    return v;
  }
}
