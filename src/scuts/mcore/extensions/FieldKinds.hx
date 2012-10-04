package scuts.mcore.extensions;

#if macro

import haxe.macro.Type;

class FieldKinds 
{
  public static function eq(v1:FieldKind, v2:FieldKind) return switch (v1) 
  {
    case FMethod(k1): switch (v2) 
    {
      case FMethod(k2): MethodKinds.eq(k1, k2);
      default:          false;
    }
    case FVar(read1, write1): switch (v2) 
    {
      case FVar(read2, write2): VarAccesses.eq(read1, read2) && VarAccesses.eq(write1, write2);
      default :                 false;
    }
  }
  
}

#end