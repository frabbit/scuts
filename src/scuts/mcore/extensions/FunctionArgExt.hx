package scuts.mcore.extensions;
import scuts.core.extensions.Bools;
import scuts.core.extensions.Strings;

import haxe.macro.Expr;

class FunctionArgExt 
{

  public static function eq (a:FunctionArg, b:FunctionArg):Bool 
  {
    return Strings.eq(a.name,b.name)
        && Bools.eq(a.opt, b.opt)
        && ((a.type == null && b.type == null) || ComplexTypeExt.eq(a.type, b.type))
        && ((a.value == null && b.value == null) || ExprExt.eq(a.value, b.value));
        
  }
  
}