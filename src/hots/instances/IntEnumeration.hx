package hots.instances;
import hots.classes.EnumerationAbstract;

class IntEnumeration extends EnumerationAbstract<Int>{
  
  public function new () {}
  
  override public inline function toEnum (i:Int):Int {
    return i;
  }
  
  override public inline function fromEnum (i:Int):Int {
    return i;
  }
}
