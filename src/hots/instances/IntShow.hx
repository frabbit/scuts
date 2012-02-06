package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;


class IntShow 
{
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new IntShowImpl();
    return instance;
  }
  
}

private class IntShowImpl extends ShowAbstract<Int> 
{
  public function new () {}
  
  override public inline function show (v:Int):String {
    return Std.string(v);
  }
}