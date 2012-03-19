package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;

class StringShow extends ShowAbstract<String> 
{
  public function new () {}
  
  override public inline function show (v:String):String {
    return v;
  }
}
