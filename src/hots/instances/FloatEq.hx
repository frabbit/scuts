package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.math.MathConstants;

class FloatEqImpl extends EqAbstract<Float> {
  
  public function new () {}

  override public function eq (a:Float, b:Float):Bool 
  {
    var diff = a - b;
    
    return (diff >= 0.0 && diff < MathConstants.EPSILON)
        || (diff <= 0.0 && diff > -MathConstants.EPSILON);
  }
  
  
  
}

typedef FloatEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(FloatEqImpl)]>;