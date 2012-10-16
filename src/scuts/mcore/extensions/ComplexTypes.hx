package scuts.mcore.extensions;

#if macro

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.core.Arrays;
import scuts.Scuts;
using scuts.core.Arrays;

class ComplexTypes 
{
  @:noUsing public static function fromString(s:String):ComplexType {
    var x = "{ var x : " + s + " = null; x;}";
    return switch (Context.parse(x, Context.currentPos()).expr) {
      case EBlock(b):
        switch (b[0].expr) {
          case EVars(v): v[0].type;
          default: Scuts.unexpected();
        }
      default: Scuts.unexpected();
    }
  }
  
  public static function eq (c1:ComplexType, c2:ComplexType):Bool return switch (c1) 
  {
    case TAnonymous(fields1): switch (c2) 
    {
      case TAnonymous(fields2): Arrays.eq(fields1, fields2, Fields.eq);
      default: false;
    }
    case TExtend(p1, fields1): switch (c2) 
    {
      case TExtend(p2, fields2): TypePaths.eq(p1, p2) && Arrays.eq(fields1, fields2, Fields.eq);
      default: false;
    }
    case TFunction(args1, ret1): switch (c2) 
    {
      case TFunction(args2, ret2):  Arrays.eq(args1, args2, ComplexTypes.eq) && ComplexTypes.eq(ret1, ret2);
      default: false;
    }
    case TOptional(t1): switch (c2) 
    {
      case TOptional(t2): eq(t1,t2);
      default: false;
    }
    case TParent(t1): switch (c2) 
    {
      case TParent(t2): eq(t1,t2);
      default: false;
    }
    case TPath(p1): switch (c2) 
    {
      case TPath(p2): TypePaths.eq(p1,p2);
      default: false;
    }
  }
  
  
  
}

#end