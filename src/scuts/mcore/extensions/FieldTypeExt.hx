package scuts.mcore.extensions;
#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;

class FieldTypeExt 
{
  
  public static function flatCopy(f:FieldType) 
  {
    return switch (f) {
      case FProp(get, set, t, e):
        FProp(get, set, t, e);
      case FFun(f):
        FFun(f);
        
      case FVar(t, e): 
        FVar(t,e);
    }
  }
  
  
}

#end