package scuts.mcore.extensions;
import scuts.core.extensions.BoolExt;
import scuts.core.extensions.StringExt;

import haxe.macro.Expr;

class FunctionArgExt 
{

  public static function eq (a:FunctionArg, b:FunctionArg):Bool 
  {
    return StringExt.eq(a.name,b.name)
        && BoolExt.eq(a.opt, b.opt)
        && ((a.type == null && b.type == null) || ComplexTypeExt.eq(a.type, b.type))
        && ((a.value == null && b.value == null) || ExprExt.eq(a.value, b.value));
        
  }
  
}