package scuts.mcore.extensions;

#if macro

import scuts.core.Arrays;
import scuts.core.Strings;
import haxe.macro.Expr;


private typedef FunctionParam = {name:String, constraints:Array<ComplexType>};

class FunctionParams 
{
  public static function eq (a:FunctionParam, b:FunctionParam):Bool 
  {
    return Strings.eq(a.name, b.name)
      && Arrays.eq(a.constraints, b.constraints, ComplexTypes.eq);
  }
}

#end