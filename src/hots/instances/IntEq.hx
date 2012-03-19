package hots.instances;
import hots.classes.EqAbstract;
import scuts.core.extensions.IntExt;

class IntEq extends EqAbstract<Int> {
  
  public function new () {}
  
  override public inline function eq (a:Int, b:Int):Bool return IntExt.eq(a,b)
  
}
