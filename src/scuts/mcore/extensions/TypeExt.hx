package scuts.mcore.extensions;
import haxe.macro.Type;

using scuts.mcore.extensions.ClassTypeExt;
using scuts.mcore.extensions.AnonTypeExt;
class TypeExt 
{

  
  
  public static function eq(t1:Type, t2:Type) 
  {
    return switch (t1) {
      case TAnonymous(a1):
        switch (t2) { case TAnonymous(a2): a1.get().eq(a2.get()); default:false; }
      case TInst(t1, params1):
        switch (t2) { case TInst(t2, params2): t1.get().eq(t2.get()); default: false; }
      case TEnum(t, params):
      case TDynamic(t):
      case TFun(args, ret):
      case TMono(t):
      case TLazy(f):
      case TType(t, params):
        
    }
  }
  
}