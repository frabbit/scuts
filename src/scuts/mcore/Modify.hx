package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;


class Modify 
{

  public static function modifyEConstCIdentValue(e:Expr, modifier:String->ExprDef):Void switch (e.expr) 
  {
    case EConst(c): switch (c) 
    {
      case CIdent(ident): e.expr = modifier(ident);
      default:
    }
    default:
  }
  
  public static function modifyEConstCStringValue(e:Expr, modifier:String->ExprDef):Void switch (e.expr) 
  {
    case EConst(c): switch (c) 
    {
      case CString(s): e.expr = modifier(s);
      default:
    }
    default:
  }

  
}

#end