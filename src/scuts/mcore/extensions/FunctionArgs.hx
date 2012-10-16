package scuts.mcore.extensions;

#if macro

import scuts.core.Bools;
import scuts.core.Strings;

import haxe.macro.Expr;

class FunctionArgs 
{
  public static function eq (a:FunctionArg, b:FunctionArg):Bool 
  {
    return Strings.eq(a.name,b.name)
        && Bools.eq(a.opt, b.opt)
        && ((a.type == null && b.type == null) || ComplexTypes.eq(a.type, b.type))
        && ((a.value == null && b.value == null) || Exprs.eq(a.value, b.value));
  }
}

#end