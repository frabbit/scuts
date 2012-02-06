package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import hots.macros.TypeClasses;



class StringEq {
  static var instance:StringEqImpl;
  
  public static function get ()
  {
    if (instance == null) instance = new StringEqImpl();
    return instance;
  }
}

class StringEqImpl extends EqAbstract<String> 
{
  public function new () {}
  
  override public inline function eq (a:String, b:String):Bool {
    return a == b;
  }
}


typedef StringProvider = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(StringEqImpl)]>;