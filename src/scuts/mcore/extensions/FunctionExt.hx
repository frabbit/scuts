package scuts.mcore.extensions;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;

class FunctionExt 
{
  public static function flatCopy(f:Function):Function 
  {
    return {
      args: f.args,
      ret: f.ret,
      expr: f.expr,
      params: f.params,
    }
  }
  
  
}

#end