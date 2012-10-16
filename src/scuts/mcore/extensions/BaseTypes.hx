package scuts.mcore.extensions;

#if macro

import haxe.macro.Type;
import haxe.macro.Expr;

using scuts.core.Arrays;
using scuts.core.Dynamics;
class BaseTypes 
{
  /*
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
  */
  
  
  public static function getFullQualifiedTypeName (type:BaseType):String 
  {
    var module = getModule(type);
    return type.pack.join(".") + (if (type.pack.length > 0) "." else "") + (module != type.name ? module + "." : "") + type.name;
  }
  
  
  public static function getFullQualifiedTypeNameWithParams (type:BaseType):String 
  {
    var typeName = getFullQualifiedTypeName(type);
	  if (type.params.length > 0) 
    {
      typeName += "<";
      var foldParams = function (acc, val, index) 
      {
        return acc + (index > 0 ? "," : "") + val.name;
      }
      typeName += type.params.foldLeftWithIndex("", foldParams);
      typeName += ">";
	  }
	  return typeName;
  }
  
  public static function getFullQualifiedImportName (type:BaseType):String 
  {
    return getFullQualifiedTypeName(type);
  }
  
  public static function getModule (type:BaseType):String 
  {
    return type.module.split(".").last();
  }
  
}

#end