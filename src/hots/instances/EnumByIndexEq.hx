package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import hots.instances.IntEq;

class EnumByIndexEq extends EqAbstract<EnumValue> {
  
  public function new () {}

  override public function eq (a:EnumValue, b:EnumValue):Bool {
    
    return IntEq.get().eq(Type.enumIndex(a),Type.enumIndex(b));
  }
}
