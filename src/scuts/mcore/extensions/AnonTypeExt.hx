package scuts.mcore.extensions;

import haxe.macro.Type;
import scuts.core.extensions.ArrayExt;

class AnonTypeExt 
{

  public static inline function eq(a1:AnonType, a2:AnonType) 
  {
    return ArrayExt.eq(a1.fields, a2.fields, ClassFieldExt.eq);
  }
  
}