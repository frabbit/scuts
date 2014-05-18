package scuts.mcore.ast;

#if macro

import haxe.macro.Expr;
import scuts.core.Strings;
import scuts.core.Options;

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
    case FFun(f):                    Some(f);
    case _ : None;
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
    
    return switch [a,b] 
    {
      case [FVar(t1, e1), FVar(t2, e2)]: varEq(t1,t2,e1,e2);
      case [FFun(f1), FFun(f2)]: Functions.eq(f1, f2);
      case [FProp(get1, set1, t1, e1), FProp(get2, set2, t2, e2)]: propEq(get1,get2, set1, set2, t1, t2, e1, e2);
      case _ : false;
    }
  }
}

#end