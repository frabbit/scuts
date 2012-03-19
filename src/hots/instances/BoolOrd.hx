package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;
import hots.instances.BoolEq;
import scuts.core.types.Ordering;



class BoolOrd extends OrdAbstract<Bool> {
  
  public function new () super(BoolEq.get())
  
  
  override public function less (a:Bool, b:Bool):Bool {
    return !a && b;
  }
  
  override public function min (a:Bool, b:Bool):Bool {
    return !a ? a : b;
  }
  
  override public function max (a:Bool, b:Bool):Bool {
    return a ? a : b;
  }
  
  
}
