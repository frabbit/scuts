package scuts.mcore.extensions;
import haxe.macro.Type;

using scuts.mcore.extensions.ClassTypeExt;

class TypeExt 
{

  
  
  public static function equals(t1:Type, t2:Type) 
  {
    return switch (t1) {
      case TAnonymous(a):
      case TInst(t1, params1):
        
        switch (t2) { case TInst(t2, params2): t1.get().equals(t2.get()); default: false; }
      case TEnum(t, params):
      case TDynamic(t):
      case TFun(args, ret):
      case TMono(t):
      case TLazy(f):
        
    }
  }
  
}