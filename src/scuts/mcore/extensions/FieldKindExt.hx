package scuts.mcore.extensions;

import haxe.macro.Type;

class FieldKindExt 
{
  public static function eq(v1:FieldKind, v2:FieldKind) 
  {
    return switch (v1) {
      case FMethod(k1):
        switch (v2) {
          case FMethod(k2): MethodKindExt.eq(k1, k2);
          default: false;
        }
      case FVar(read1, write1):
        
    }
  }
  
}