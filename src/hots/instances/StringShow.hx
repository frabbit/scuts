package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;

class StringShow
{
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new StringShowImpl();
    return instance;
  }
}

private class StringShowImpl extends ShowAbstract<String> 
{
  public function new () {}
  
  override public inline function show (v:String):String {
    return v;
  }
}