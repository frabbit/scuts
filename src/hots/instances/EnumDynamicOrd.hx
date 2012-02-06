package hots.instances;

import hots.classes.Ord;

class OrdEnumDynamic {
  
  public static var get(getInstance, null):OrdEnumDynamicImpl;
  
  static function getInstance ()
  {
    if (get == null) get = new OrdEnumDynamicImpl(EqEnumByIndex.get);
    return get;
  }
}

class OrdEnumDynamicImpl extends OrdDefault<Enum<Dynamic>> {
  
  function new (eq) { super(eq);}

  override public function lessOrEq (a:Enum<Dynamic>, b:Enum<Dynamic>):Bool {
    return Type.enumIndex(a) <= Type.enumIndex(b);
  }
}