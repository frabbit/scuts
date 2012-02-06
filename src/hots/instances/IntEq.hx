package hots.instances;

import hots.classes.Eq;

class EqInt{

  public static var get(getInstance, null):EqIntImpl;
  
  static function getInstance ()
  {
    if (get == null) get = new EqIntImpl();
    return get;
  }
}

class EqIntImpl extends EqDefault<Int> {
  
  public function new () {}
  
  override public inline function eq (a:Int, b:Int):Bool {
    return a == b;
  }
  
}