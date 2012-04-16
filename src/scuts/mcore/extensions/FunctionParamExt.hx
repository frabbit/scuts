package scuts.mcore.extensions;
import scuts.core.extensions.Arrays;
import scuts.core.extensions.Strings;
import haxe.macro.Expr;


private typedef FunctionParam = {name:String, constraints:Array<ComplexType>};

class FunctionParamExt 
{
  public static function eq (a:FunctionParam, b:FunctionParam):Bool 
  {
    return Strings.eq(a.name, b.name)
      && Arrays.eq(a.constraints, b.constraints, ComplexTypeExt.eq);
  }
  
  
}