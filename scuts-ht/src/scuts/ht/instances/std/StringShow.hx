package scuts.ht.instances.std;
import scuts.ht.classes.Show;

class StringShow implements Show<String> 
{
  public function new () {}
  
  public inline function show (v:String):String {
    return v;
  }
}
