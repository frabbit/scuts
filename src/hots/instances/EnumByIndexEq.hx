package hots.instances;

import hots.classes.Eq;

class EqEnumByIndex  {
  
  public static var get(getInstance, null):EqEnumByIndexImpl;
  
  static function getInstance ()
  {
    if (get == null) get = new EqEnumByIndexImpl();
    return get;
  }
  
}

private class EqEnumByIndexImpl extends EqDefault<Enum<Dynamic>> {
  
  public function new () {}

  override public function eq (a:Enum<Dynamic>, b:Enum<Dynamic>):Bool {
    return EqInt.get.eq(Type.enumIndex(a),Type.enumIndex(b));
  }
}