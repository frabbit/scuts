package scuts.mcore.ast;

#if macro

import haxe.macro.Expr;

class Accesses 
{

  public static function eq (a:Access, b:Access):Bool 
  {
    return switch [a, b] {
      case [AMacro, AMacro]: true;
      case [AInline, AInline]: true;
      case [ADynamic, ADynamic]: true;
      case [AStatic, AStatic]: true;
      case [APublic, APublic]: true;
      case [APrivate, APrivate]: true;
      case [AOverride, AOverride]: true;
      case _ : false;
    }
  }
  
}

#end