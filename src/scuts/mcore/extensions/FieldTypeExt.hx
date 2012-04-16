package scuts.mcore.extensions;
#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;
import scuts.core.extensions.Strings;
import scuts.core.types.Option;

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
  
  public static function asFunction(f:FieldType):Option<Function>
  {
    return switch (f) {
      case FProp(_,_,_,_), FVar(_, _): 
        None;
      case FFun(f):
        Some(f);
    }
  }
  
  public static function eq (a:FieldType, b:FieldType):Bool 
  {
    // haxe really needs pattern matching as a language feature :(
    return switch (a) {
      case FVar(t1, e1):   
        switch (b) { 
          case FVar(t2, e2): 
            ((t2 == null && t1 == null) || ComplexTypeExt.eq(t1, t2))
            && ((e1 == null && e2 == null) || ExprExt.eq(e1, e2));
          default: false;
        }
      case FFun(f1):  
        switch (b) { 
          case FFun(f2): 
            Functions.eq(f1, f2);
          default: false;
        } 
      case FProp(get1, set1, t1, e1):   
        switch (b) { 
          case FProp(get2, set2, t2, e2):    
               Strings.eq(get1, get2)
            && Strings.eq(get1, get2)
            && ComplexTypeExt.eq(t1, t2)
            && ((e1 == null && e2 == null) || ExprExt.eq(e1, e2));
          default: false;
        } 
      
    }
  }
  
  
}

#end