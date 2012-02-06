package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;


class BoolShow {
  
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new BoolShowImpl();
    return instance;
  }
}

private class BoolShowImpl extends ShowAbstract<Bool> 
{
  public function new () {}

  override public inline function show (v:Bool):String {
    return Std.string(v);
  }
}