package scuts.mcore.extensions;

import haxe.macro.Type;
import haxe.macro.Expr;

using scuts.core.extensions.Arrays;
using scuts.core.extensions.Dynamics;
class BaseTypes 
{

  public static function toTypePath(b:BaseType, params:Array<Type>, wildcards:Array<Type>):TypePath 
  {
    var params = params.map(function (p) return TPType(Types.toComplexType(p, wildcards)));
    
    return { pack: b.pack, name: b.name, params: params }
  }
  
  public static function toComplexType (b:BaseType, params:Array<Type>, wildcards:Array<Type>):ComplexType
  {
    wildcards.nullGetOrElse(function () return []);
    return ComplexType.TPath(toTypePath(b, params, wildcards));
  }
  
}