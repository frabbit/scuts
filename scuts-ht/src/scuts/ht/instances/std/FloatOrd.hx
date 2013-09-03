package scuts.ht.instances.std;

import scuts.ht.classes.Eq;
import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.core.Ordering;

class FloatOrd extends OrdAbstract<Float> 
{
  
  public function new (eq:Eq<Float>) 
  { 
    super(eq);
  }
  
  override public inline function lessOrEq (a:Float, b:Float):Bool 
  {
    return a <= b;
  }
  
  override public inline function less (a:Float, b:Float):Bool 
  {
    return a < b;
  }
  
  override public inline function greater (a:Float, b:Float):Bool 
  {
    return a > b;
  }
  
  override public inline function greaterOrEq (a:Float, b:Float):Bool 
  {
    return a >= b;
  }
  
  override public inline function min (a:Float, b:Float):Float 
  {
    return a < b ? a : b;
  }
  override public inline function max (a:Float, b:Float):Float 
  {
    return a > b ? a : b;
  }
  
  override public inline function compare (a:Float, b:Float):Ordering 
  {
    return 
      if (a < b)      Ordering.LT 
      else if (a > b) Ordering.GT 
      else            Ordering.EQ;
  }
  
  override public inline function compareInt (a:Float, b:Float):Int 
  {
    return 
      if (a < b)      -1 
      else if (a > b)  1 
      else             0;
  }
}
