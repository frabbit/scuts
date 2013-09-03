package scuts.mcore.ast;

#if macro

import haxe.macro.Type;

class MethodKinds 
{

  public static function eq(v1:MethodKind, v2:MethodKind) return switch [v1, v2] 
  {
    case [MethDynamic, MethDynamic]: true;
    case [MethInline, MethInline]: true;
    case [MethMacro, MethMacro]: true;
    case [MethNormal, MethNormal]: true;
    case _ : false;
  }
  
}

#end