package scuts.mcore.extensions;

import haxe.macro.Type;
import haxe.macro.Expr;

using scuts.core.extensions.ArrayExt;

class BaseTypeExt 
{

  public static function toTypePath(b:BaseType, params:Array<Type>):TypePath 
  {
    return {
      pack: b.pack,
      name: b.name,
      params: params.map(function (p) return TPType(TypeExt.toComplexType(p)))
    }
  }
  
  public static function toComplexType (b:BaseType, params:Array<Type>):ComplexType
  {
    return ComplexType.TPath(toTypePath(b, params));
  }
  
}