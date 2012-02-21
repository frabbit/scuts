package scuts.mcore.extensions;
import scuts.core.extensions.ArrayExt;
import scuts.core.extensions.StringExt;
import haxe.macro.Expr;


private typedef FunctionParam = {name:String, constraints:Array<ComplexType>};

class FunctionParamExt 
{
  public static function eq (a:FunctionParam, b:FunctionParam):Bool 
  {
    return StringExt.eq(a.name, b.name)
      && ArrayExt.eq(a.constraints, b.constraints, ComplexTypeExt.eq);
  }
  
  
}