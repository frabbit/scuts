package scuts.mcore.ast;

#if macro

import haxe.macro.Expr;

class TypeParams 
{
  public static function eq (a:TypeParam, b:TypeParam):Bool return switch [a,b] 
  {
    case [TPExpr(e1), TPExpr(e2)]: Exprs.eq(e1, e2);
    case [TPType(ct1), TPType(ct2)]: ComplexTypes.eq(ct1, ct2);
    case _ : false;
  }
  
}

#end