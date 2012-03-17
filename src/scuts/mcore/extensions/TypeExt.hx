package scuts.mcore.extensions;
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.core.extensions.ArrayExt;
import scuts.core.types.Tup2;
import scuts.core.types.Option;
import scuts.Scuts;

using scuts.core.extensions.ArrayExt;
using scuts.mcore.extensions.ClassTypeExt;
using scuts.mcore.extensions.EnumTypeExt;
using scuts.mcore.extensions.DefTypeExt;
using scuts.mcore.extensions.AnonTypeExt;

using scuts.core.extensions.DynamicExt;
using scuts.mcore.extensions.TypeExt;
class TypeExt 
{

  public static inline function isTInst (t:Type):Bool {
    return switch (t) {
      case TInst(_,_): true;
      default: false;
    }
  }
  
  public static function toComplexType (t:Type, wildcards:Array<Type>):ComplexType {
    
    
    return if (isTInst(t) && wildcards.any(function (x) return TypeExt.eq(x, t))) {
      // wildcards must be TInst
      switch (t) {
        case TInst(t, _):
          TPath({
            pack: [],
            name: t.get().name,
            params: []
          });
        default: Scuts.unexpected();
      }
    } else {
      return switch (t) {
        case TEnum(t, params): BaseTypeExt.toComplexType(t.get(), params, wildcards);
        case TInst(t, params): BaseTypeExt.toComplexType(t.get(), params, wildcards);
        case TType(t, params): BaseTypeExt.toComplexType(t.get(), params, wildcards);
        case TLazy(t):         toComplexType(t(), wildcards);
        case TFun(args, ret):  ComplexType.TFunction(args.map(function (a) return toComplexType(a.t, wildcards)), toComplexType(ret, wildcards));
        case TAnonymous(a):    Scuts.notImplemented();
        case TMono(t):         Scuts.notImplemented();
        case TDynamic(t):      Scuts.notImplemented();
      }
    }
  }
  
  public static function asFunction(t:Type) 
  {
    return switch (t) 
    {
      case TFun(args, ret): Some(Tup2.create(args, ret));
      default:              None;
    }
  }
  
  
  public static function eq(type1:Type, type2:Type):Bool 
  {
    
    var eqParams = function (p1, p2) return ArrayExt.eq(p1, p2, TypeExt.eq);
    return switch (type1) {
      case TAnonymous(a1):
        switch (type2) 
        { 
          case TAnonymous(a2): a1.get().eq(a2.get()); 
          default : false; 
        }
      case TInst(t1, params1):
        switch (type2) 
        { 
          case TInst(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
          default : false; 
        }
      case TEnum(t1, params1):
        switch (type2) 
        { 
          case TEnum(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
          default : false; 
        }
      case TType(t1, params1):
        switch (type2) 
        { 
          case TType(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
          default : false; 
        }
      case TDynamic(t1):
        switch (type2) 
        { 
          case TDynamic(t2): t1.nullEq(t2, eq);
          default : false; 
        }
      case TFun(args, ret): Scuts.notImplemented();
      case TMono(t): Scuts.notImplemented();
      case TLazy(f): Scuts.notImplemented();
      
    }
  }
  
  public static function asClassType (t:Type) {
    return switch (t) {
      case TInst(t, params):
        Some(Tup2.create(t, params));
      default: None;
    }
  }
  
}