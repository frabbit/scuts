package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;
import scuts.core.Strings;
import scuts.core.Option;

class FieldTypes 
{
  public static function flatCopy(f:FieldType) return switch (f) 
  {
    case FProp(get, set, t, e): FProp(get, set, t, e);
    case FFun(f):               FFun(f);
    case FVar(t, e):            FVar(t,e);
  }
  
  public static function asFunction(f:FieldType):Option<Function> return switch (f) 
  {
    case FProp(_,_,_,_), FVar(_, _): None;
    case FFun(f):                    Some(f);
  }
  
  public static function eq (a:FieldType, b:FieldType):Bool 
  {
    function varEq (t1,t2, e1, e2) 
    {
      return ((t2 == null && t1 == null) || ComplexTypes.eq(t1, t2))
          && ((e1 == null && e2 == null) || Exprs.eq(e1, e2));
    }
    
    function propEq (get1, get2, set1, set2, t1, t2, e1, e2) 
    {
      return Strings.eq(get1, get2)
          && Strings.eq(get1, get2)
          && ComplexTypes.eq(t1, t2)
          && ((e1 == null && e2 == null) || Exprs.eq(e1, e2));
    }
    
    return switch (a) 
    {
      case FVar(t1, e1):  switch (b) 
      { 
        case FVar(t2, e2): varEq(t1,t2,e1,e2);
        default:           false;
      }
      case FFun(f1): switch (b) 
      { 
        case FFun(f2): Functions.eq(f1, f2);
        default:       false;
      } 
      case FProp(get1, set1, t1, e1):  switch (b) 
      { 
        case FProp(get2, set2, t2, e2): propEq(get1,get2, set1, set2, t1, t2, e1, e2);
        default:                        false;
      } 
    }
  }
}

#end