package scuts1.instances.std;
import scuts1.classes.EqAbstract;
import scuts.core.Ints;

class IntEq extends EqAbstract<Int> {
  
  public function new () {}
  
  override public inline function eq (a:Int, b:Int):Bool return Ints.eq(a,b);
  
}
