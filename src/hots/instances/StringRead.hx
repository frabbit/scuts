package hots.instances;
import hots.classes.Read;
import hots.classes.ReadAbstract;

class StringRead {
  
  static var instance:StringReadImpl;
  
  static function get ()
  {
    if (instance == null) instance = new StringReadImpl();
    return instance;
  }
  
}

private class StringReadImpl extends ReadAbstract<String> {
  
   public function new () {}
  
  override public inline function read (v:String):String {
    return v;
  }
}