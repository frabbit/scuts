package hots.instances;
import hots.classes.Read;
import hots.classes.ReadAbstract;



class StringRead extends ReadAbstract<String> {
  
  public function new () {}
  
  override public inline function read (v:String):String {
    return v;
  }
}
