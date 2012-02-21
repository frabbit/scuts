package scuts.mcore.extensions;

import haxe.macro.Expr;

class TypeParamExt 
{

  public static function eq (a:TypeParam, b:TypeParam):Bool {
    return switch (a) 
    {
      case TPExpr(e1):
        switch (b) 
        {
          case TPExpr(e2): ExprExt.eq(e1, e2);
          default: false;
        }
      case TPType(ct1): 
        switch (b) 
        {
          case TPType(ct2): ComplexTypeExt.eq(ct1, ct2);
          default: false;
        }
    }
  }
  
}