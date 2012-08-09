package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;



class EnumByIndexOrd extends OrdAbstract<EnumValue> 
{
  
  public function new (eq) super(eq)

  override public function lessOrEq (a:EnumValue, b:EnumValue):Bool 
  {
    return Type.enumIndex(a) <= Type.enumIndex(b);
  }
}
