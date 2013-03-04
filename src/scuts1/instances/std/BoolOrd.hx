package scuts1.instances.std;

import scuts1.classes.Ord;
import scuts1.classes.OrdAbstract;
import scuts1.instances.std.BoolEq;
import scuts.core.Ordering;



class BoolOrd extends OrdAbstract<Bool> 
{
  public function new (eq) super(eq);
  
  override public function less (a:Bool, b:Bool):Bool return !a && b;
  
  override public function min (a:Bool, b:Bool):Bool return !a ? a : b;
  
  override public function max (a:Bool, b:Bool):Bool return a ? a : b;
}
