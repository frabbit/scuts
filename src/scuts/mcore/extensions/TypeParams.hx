package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;

class TypeParams 
{
  public static function eq (a:TypeParam, b:TypeParam):Bool return switch (a) 
  {
    case TPExpr(e1): switch (b) 
    {
      case TPExpr(e2): Exprs.eq(e1, e2);
      default:         false;
    }
    case TPType(ct1): switch (b) 
    {
      case TPType(ct2): ComplexTypes.eq(ct1, ct2);
      default:          false;
    }
  }
  
}

#end