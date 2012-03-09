package scuts.mcore.extensions;
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.core.extensions.ArrayExt;


using scuts.core.extensions.ArrayExt;
using scuts.mcore.extensions.ClassTypeExt;
using scuts.mcore.extensions.DefTypeExt;
using scuts.mcore.extensions.AnonTypeExt;

class TypeExt 
{

  
  
  public static function toComplexType (t:Type) {
    return switch (t) {
      case TEnum(t, params):
        BaseTypeExt.toComplexType(t.get(), params);
      case TInst(t, params):
        BaseTypeExt.toComplexType(t.get(), params);
      case TType(t, params):
        BaseTypeExt.toComplexType(t.get(), params);
      case TLazy(t): 
        toComplexType(t());
      case TFun(args, ret):
        ComplexType.TFunction(args.map(function (a) return toComplexType(a.t)), toComplexType(ret));
      case TAnonymous(a):
      
      case TMono(t): null;
      case TDynamic(t): null;
    }
  }
  
  
  public static function eq(t1:Type, t2:Type) 
  {
    return switch (t1) {
      case TAnonymous(a1):
        switch (t2) { case TAnonymous(a2): a1.get().eq(a2.get()); default:false; }
      case TInst(t1, params1):
        switch (t2) { case TInst(t2, params2): t1.get().eq(t2.get()) && ArrayExt.eq(params1, params2, TypeExt.eq); default: false; }
      case TEnum(t, params):
      case TDynamic(t):
      case TFun(args, ret):
      case TMono(t):
      case TLazy(f):
      case TType(t1, params1):
        switch (t2) { case TType(t2, params2): t1.get().eq(t2.get()) && ArrayExt.eq(params1, params2, TypeExt.eq); default: false; }
        
    }
  }
  
}