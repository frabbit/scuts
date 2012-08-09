package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import hots.instances.IntEq;

class EnumByIndexEq extends EqAbstract<EnumValue> 
{
  
  private var intEq:Eq<Int>;
  
  public function new (intEq) {
    this.intEq = intEq;
  }

  override public function eq (a:EnumValue, b:EnumValue):Bool {
    
    return intEq.eq(Type.enumIndex(a),Type.enumIndex(b));
  }
}
