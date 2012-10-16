package scuts.mcore.extensions;

#if macro

import haxe.macro.Type;
import scuts.core.Arrays;

class AnonTypes
{

  public static inline function eq(a1:AnonType, a2:AnonType) 
  {
    return Arrays.eq(a1.fields, a2.fields, ClassFields.eq);
  }
  
}

#end