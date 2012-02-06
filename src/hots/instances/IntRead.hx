package hots.instances;
import hots.classes.Read;
import scuts.Scuts;

class ReadInt {
  
  public static var get(getInstance, null):ReadIntImpl;
  
  static function getInstance ()
  {
    if (get == null) get = new ReadIntImpl();
    return get;
  }
  
}

private class ReadIntImpl implements Read<Int> {
  
  public function new () {}
  
  override public function read (v:String):Int {
    var val = Std.parseInt(v);
    if (val == null) Scuts.error("cannot convert String '" + v + "' to Int");
    return val;
  }
}