package scuts.mcore.extensions;

import haxe.macro.Type;
import haxe.macro.Expr;

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.DynamicExt;
class BaseTypeExt 
{

  public static function toTypePath(b:BaseType, params:Array<Type>, wildcards:Array<Type>):TypePath 
  {
    return {
      pack: b.pack,
      name: b.name,
      params: params.map(function (p) return TPType(TypeExt.toComplexType(p, wildcards)))
    }
  }
  
  public static function toComplexType (b:BaseType, params:Array<Type>, wildcards:Array<Type>):ComplexType
  {
    wildcards.nullGetOrElse(function () return []);
    return ComplexType.TPath(toTypePath(b, params, wildcards));
  }
  
}