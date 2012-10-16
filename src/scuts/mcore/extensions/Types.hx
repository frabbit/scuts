package scuts.mcore.extensions;

#if macro

import haxe.macro.Context;
import haxe.macro.Type;
import scuts.core.Validation;
import scuts.mcore.Make;
import scuts.mcore.Print;

import scuts.Scuts;

import haxe.macro.Expr;



import scuts.core.Tup2;
import scuts.core.Option;

using scuts.core.Dynamics;

using scuts.core.Arrays;

using scuts.core.Strings;
using scuts.core.Bools;
using scuts.core.Functions;



using scuts.mcore.extensions.Types;

using scuts.mcore.extensions.ClassTypes;
using scuts.mcore.extensions.EnumTypes;
using scuts.mcore.extensions.DefTypes;
using scuts.mcore.extensions.AnonTypes;

enum InstType 
{
	ITRegular;
  ITFunctionParam;
  ITClassParam;
}

private typedef TFunArg = {t:Type, name:String, opt:Bool};

class Types 
{
  
 

  public static function isFunction (t:Type):Bool 
  {
    return switch (t) {
      case TFun(_,_): true;
      default: false;
    }
  }
  
  public static function isMono (t:Type):Bool 
  {
    return switch (t) {
      case TMono(_): true;
      default: false;
    }
  }
  
  public static function getInstType (c:ClassType):InstType
  {
    var pack = c.pack;
    var module = c.module;
    var packJoined = pack.join(".");
    
    return 
      if (packJoined == module)                  ITClassParam
      else if (module.indexOf(packJoined) == -1) ITFunctionParam
      else                                       ITRegular;
  }
  
  public static function eq(type1:Type, type2:Type):Bool 
  {
    var eqParams = Arrays.eq.partial3(Types.eq);
    
    function funEq (args1, args2, ret1:Type, ret2:Type) 
    {
      function funArgEq(a1:TFunArg, a2:TFunArg) 
      {
        return a1.name.eq(a2.name) 
            && a1.opt.eq(a2.opt) 
            && a1.t.eq(a2.t);
      }
      return Arrays.eq(args1, args2, funArgEq) && ret1.eq(ret2);
    }
    
    
    return switch type1 
    {
      case TAbstract(x,y): Scuts.notImplemented();
      case TAnonymous(a1): switch type2
      { 
        case TAnonymous(a2): a1.get().eq(a2.get()); 
        default :            false; 
      }
      case TInst(t1, params1): switch (type2) 
      { 
        case TInst(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
        default :                false; 
      }
      case TEnum(t1, params1): switch type2 
      { 
        case TEnum(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
        default :                false; 
      }
      case TType(t1, params1): switch type2 
      { 
        case TType(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
        default :                false; 
      }
      case TDynamic(t1): switch type2 
      { 
        case TDynamic(t2): t1.nullEq(t2, eq);
        default :          false; 
      }
      case TFun(args1, ret1): switch type2
      {
        case TFun(args2, ret2): funEq(args1, args2, ret1, ret2);
        default:                false;
      }
      case TMono(t1): switch type2 
      { 
        case TMono(t2): t1.get().nullEq(t2.get(), eq);
        default :       false; 
      }
      case TLazy(f1): switch type2 
      { 
        case TLazy(f2): f1().eq(f2());
        default :       false; 
      }
    }
  }
  
  public static function toComplexType (t:Type, ?pos:Position):Validation<Error, ComplexType>
	{
    var p = if (pos == null) Context.currentPos() else pos;
    var s = Print.type( t, true);
		return Success(ComplexTypes.fromString(s));
	}
}

#end