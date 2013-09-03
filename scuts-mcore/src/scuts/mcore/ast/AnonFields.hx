package scuts.mcore.ast;

#if macro

import haxe.macro.Expr;
import scuts.core.Strings;
import scuts.mcore.Make;

private typedef AnonField = { field : String, expr : Expr };

class AnonFields
{
  public static function eq (a:AnonField, b:AnonField, exprPosEq : Bool = true):Bool 
  {
    return Strings.eq(a.field, b.field) && Exprs.eq(a.expr, b.expr, exprPosEq);
  }
}


#end