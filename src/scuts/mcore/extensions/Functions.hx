package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;
import scuts.core.Arrays;


class Functions 
{
  public static function eq (a:Function, b:Function):Bool 
  {
    return Arrays.eq(a.args,b.args, FunctionArgs.eq)
        && ((a.ret == null && b.ret == null) || ComplexTypes.eq(a.ret, b.ret))
        && ((a.expr == null && b.expr == null) || Exprs.eq(a.expr, b.expr))
        && Arrays.eq(a.params, b.params, FunctionParams.eq);
  }

}

#end