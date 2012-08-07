package scuts.mcore.extensions;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;
import scuts.core.extensions.Arrays;


class Functions 
{
  public static function eq (a:Function, b:Function):Bool 
  {
    return Arrays.eq(a.args,b.args, FunctionArgs.eq)
        && ((a.ret == null && b.ret == null) || ComplexTypes.eq(a.ret, b.ret))
        && ((a.expr == null && b.expr == null) || Exprs.eq(a.expr, b.expr))
        && Arrays.eq(a.params, b.params, FunctionParams.eq);
  }
  
  public static function addArg (f:Function, name:String, opt:Bool, ?type:ComplexType, ?value:Expr ):Function return 
  {
    args:   f.args.concat([{ name:name, opt:opt, type:type, value:value}]),
    ret:    f.ret,
    expr:   f.expr,
    params: f.params,
  }
  
  public static function returns (f:Function, ret:ComplexType):Function return 
  {
    args:   f.args,
    ret:    ret,
    expr:   f.expr,
    params: f.params,
  }
  
  public static function body (f:Function, expr:Expr):Function return 
  {
    args:   f.args,
    ret:    f.ret,
    expr:   expr,
    params: f.params,
  }
  
  public static function addParam (f:Function, name:String, constraints:Array<ComplexType>):Function return 
  {
    args:   f.args,
    ret:    f.ret,
    expr:   f.expr,
    params: f.params.concat([{name:name, constraints:constraints}]),
  }
  
  public static function flatCopy(f:Function):Function return 
  {
    args:   f.args,
    ret:    f.ret,
    expr:   f.expr,
    params: f.params,
  }
  
  
}

#end