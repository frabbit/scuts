package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;


import scuts.CoreTypes;

/*
switch (e.expr) {
  case EConst( c  ):
  case EArray( e1 , e2 ):
  case EBinop( op , e1 , e2 ):
  case EField( e , field ):
  case EType( e , field ):
  case EParenthesis( e ):
  case EObjectDecl( fields ):
  case EArrayDecl( values ):
  case ECall( e , params ):
  case ENew( t , params  ):
  case EUnop( op , postFix , e ):
  case EVars( vars ):
  case EFunction( name , f ):
  case EBlock( exprs  ):
  case EFor( it , expr ):
  case EIn( e1 , e2 ):
  case EIf( econd , eif , eelse  ):
  case EWhile( econd , e , normalWhile ):
  case ESwitch( e , cases , edef ):
  case ETry( e , catches  ):
  case EReturn( e ):
  case EBreak:
  case EContinue:
  case EUntyped( e ):
  case EThrow( e ):
  case ECast( e , t ):
  case EDisplay( e , isCall ):
  case EDisplayNew( t ):
  case ETernary( econd , eif , eelse ):
}

*/


class Extract 
{
  /*
  public static function extractAllExprWithIdent (e:Expr, i:String):Array<{e:Expr, chain:Array<Expr>}> {
    
    function f1 = function (e:Expr, i:String, chain:Array) {
      var f = f1.curry(i);
    
      return switch (e.expr) {
        case EConst( c  ):
          [];
        case EArray( e1 , e2 ):
          [];
        case EBinop( op , e1 , e2 ):
        case EField( e , field ):
          f(e);
        case EType( e , field ):
        case EParenthesis( e ):
        case EObjectDecl( fields ):
        case EArrayDecl( values ):
        case ECall( e , params ):
        case ENew( t , params  ):
        case EUnop( op , postFix , e ):
        case EVars( vars ):
        case EFunction( name , f ):
        case EBlock( exprs  ):
        case EFor( it , expr ):
        case EIn( e1 , e2 ):
        case EIf( econd , eif , eelse  ):
        case EWhile( econd , e , normalWhile ):
        case ESwitch( e , cases , edef ):
        case ETry( e , catches  ):
        case EReturn( e ):
        case EBreak:
        case EContinue:
        case EUntyped( e ):
        case EThrow( e ):
        case ECast( e , t ):
        case EDisplay( e , isCall ):
        case EDisplayNew( t ):
        case ETernary( econd , eif , eelse ):
      }
    }
    
  }
  */
  public static function extractOptionalExpr (o:Expr):Option<Expr>
  {
    return switch (o.expr) 
    {
      case EConst(c): switch (c) 
      {
        case CIdent(s): s == "null" ? None : Some(o);
        default: Some(o);
      }
      default: Some(o);
    }
  }
  
  public static function extractArrayDeclValues (e:Expr):Option<Array<Expr>> {
    return switch (e.expr) {
      case EArrayDecl(v): Some(v);
      default: None;
    }
  }
  
  
  
  public static function extractConstString (e:Expr):Option<String> {
    return switch (e.expr) {
      case EConst(c): 
        switch (c) {
          case CString(s): Some(s);
          default: None;
        }
      default: None;
    }
  }

}

#end