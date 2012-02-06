package hots.instances;
import hots.classes.Enumeration;



class EnumerationInt {
  public static var get(getInstance, null):EnumerationIntImpl;
  
  static function getInstance ()
  {
    if (get == null) get = new EnumerationIntImpl();
    return get;
  }
}

private class EnumerationIntImpl extends Enumeration<Int>{
  
  public function new () {}
  
  override public function toEnum (i:Int):Int {
    return i;
  }
  
  override public function fromEnum (i:Int):Int {
    return i;
  }
}