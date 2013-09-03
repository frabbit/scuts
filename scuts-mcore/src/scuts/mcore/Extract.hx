package scuts.mcore;

#if (macro)

import haxe.macro.Expr;
import scuts.core.Options;




class Extract 
{
  
  public static function extractOptionalExpr (o:Expr):Option<Expr> return switch (o.expr) 
  {
    case EConst(c): switch (c) 
    {
      case CIdent(s): s == "null" ? None : Some(o);
      default:        Some(o);
    }
    default: Some(o);
  }

  public static function extractArrayDeclValues (e:Expr):Option<Array<Expr>> return switch (e.expr) 
  {
    case EArrayDecl(v): Some(v);
    default:            None;
  }
  
  public static function extractConstString (e:Expr):Option<String> return switch (e.expr) 
  {
    case EConst(c): switch (c) 
    {
      case CString(s): Some(s);
      default:         None;
    }
    default: None;
  }
  
  public static function extractBinOpRightExpr (e:Expr, filter:Binop->Bool ):Option<Expr> return switch (e.expr) 
  {
    case EBinop(b, _, e2): if (filter(b)) Some(e2) else None;
    default:                None;
  }

}

#end