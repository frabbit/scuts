package scuts.mcore;

#if macro

import haxe.macro.Expr;


class Modify 
{

  public static function modifyEConstCIdentValue(e:Expr, modifier:String->ExprDef):Void switch (e.expr) 
  {
    case EConst(CIdent(id)): e.expr = modifier(id);
    case _:
  }
  
  public static function modifyEConstCStringValue(e:Expr, modifier:String->ExprDef):Void switch (e.expr) 
  {
    case EConst(CString(s)): e.expr = modifier(s);
    case _:
  }

  
}

#end