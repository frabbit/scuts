package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
using scuts.core.Arrays;
using scuts.core.Iterables;
using scuts.core.Dynamics;
using scuts.core.Options;

import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.core.Predicates;

import scuts.CoreTypes;


class Check 
{
  public static function isConstantTypeDecl (t:ComplexType):Bool return switch (t) 
  {
    case TPath(p):
      if (p.pack.length > 0) false
      else switch (p.name) 
      {
        case "Int": true;
        case "Float": true;
        case "String": true;
        case "Array":
          if (p.params.length != 1) false
          else switch (p.params[0]) 
          {
            case TPType(t): isConstantTypeDecl(t);
            default:        false;
          }
        default: false;  
      }
    case TAnonymous(fields):
      var isConstant = true;
      
      for (f in fields) 
      {
        switch (f.kind) 
        {
          case FieldType.FVar(t, _):
            if (!isConstantTypeDecl(t)) 
            {
              isConstant = false;
              break;
            }
          default: 
            isConstant = false;
            break;
        }
      }
      isConstant;
    default: 
      false;
  }
  
  public static function isConstantExpr (expr:Expr):Bool return switch (expr.expr) 
  {
    case EArrayDecl(exprs):
      var isConstant = true;
      
      for (e in exprs) 
      {
        if (!isConstantExpr(e)) 
        {
          isConstant = false;
          break;
        }
      }
      isConstant;
      
    case EObjectDecl(fields):
      var isConstant = true;
      
      for (f in fields) 
      {
        if (!isConstantExpr(f.expr)) 
        {
          isConstant = false;
          break;
        }
      }
      
      isConstant;
      
    case EConst(c): switch (c) 
    {
      case CInt(_), CString(_), CFloat(_): true;
      default:                             false;
    }
    default: false;
  }
  
  public static function isEmptyBlock (expr:Expr) return switch (expr.expr) 
  {
    case EBlock(exprs): exprs.length == 0;
    default:            false;
  }
  
  private static function hasNonVoidReturn(expr:Expr):Bool 
  {
    if (expr == null) return false;
    
    var has = hasNonVoidReturn;
    
    return switch (expr.expr) 
    {
      case EBlock(exprs):
        exprs.filter(function (e) return has(e)).length > 0;
      case EIf(econd, eif, eelse):
        has(econd) || has(eif) || has(eelse);
      case ESwitch(e, cases, edef):
        has(e) || has(edef) || cases.filter(function (c) return has(c.expr)).length > 0;
      case ETry(e, catches):
        has(e) ||  catches.filter(function (c) return has(c.expr)).length > 0;
      case ExprDef.EFor(it, e):
        has(it) || has(e);
      case ExprDef.EParenthesis(e):
        has(e);
      case ExprDef.EBinop(_, e1, e2):
        has(e1) || has(e2);
      case ExprDef.EReturn(e):
        e != null;
      case ExprDef.EWhile(econd, e, _):
        has(econd) || has(e);
      case EVars(_), EThrow(_), EType(_,_), ENew(_,_), EField(_,_), EDisplayNew(_), EDisplay(_), EContinue, EBreak:
        false;
      default: false;
    }
  }
  
  public static function isBlockAndLastExprIsVoidReturn (e:Expr):Bool return switch (e.expr) 
  {
    case EBlock(exprs):
      
      if (exprs.length > 0) 
      {
        var lastExpr = exprs[exprs.length - 1];
        
        switch (lastExpr.expr) 
        {
          case EReturn(ret): ret == null;
          case EBlock(block): isBlockAndLastExprIsVoidReturn(lastExpr);
          default:            false;
        }
      }
      else false;
      
    default: false;
  }
  
  public static function isVoidFunction (f:Function) 
  {
    var hasReturnVoidType = 
      f.ret != null 
      && switch (f.ret) 
      {
        case TPath(p): p.name == "Void" && p.pack.length == 0;
        default:       false;
      };
      
    return hasReturnVoidType || !hasNonVoidReturn(f.expr);
  }
  
	public static function isExpr (o:Dynamic) 
  {
		return Reflect.isObject(o) 
      &&   Reflect.hasField(o, "expr") 
			&&   Reflect.hasField(o, "pos") 
			&&   Std.is(Reflect.field(o, "expr"), ExprDef);
	}
  
  public static function isArrayDecl (e:Expr):Bool 
  {
    return switch (e.expr) 
    {
      case EArrayDecl(_): true;
      default:            false;
    }
  }
  
  
  public static function isConstIdent (e:Expr, ?f:String->Bool) 
  {
    f = f.nullGetOrElseConst(function (s) return true);
    
    return switch (e.expr) 
    {
      case EConst(c): switch (c) 
      {
        case CIdent(i): return f(i);
        default: false;
      }
      default: false;
    }
  }
  
  public static function isConst (e:Expr) return switch (e.expr) 
  {
    case EConst(_): true;
    default: false;
  }
  
  public static inline function isConstString (e:Expr) 
  {
    return Extract.extractConstString(e).isSome();
  }
  
  public static function isConstNull (e:Expr) 
  {
    return isConstIdent(e, function (x) return x == "null");
  }
  
  public static function isType (e:Expr) return switch (e.expr) 
  {
    case EConst(c): switch (c) 
    {
      case CType(_): true;
      default:       false;
    }
    case EType(_, _): true;
    default: false;
  }
  
  //EConst
  public static function isEConst (e:Expr):Bool return switch (e.expr) 
  {
    case EConst(_): true;
    default:        false;
  }
  
  // EBlock
  public static function isEBlock (e:Expr):Bool return switch (e.expr) 
  {
    case EBlock(c): true;
    default:        false;
  }
  
  // EArray( e1 : Expr, e2 : Expr );
  public static function isEArray (e:Expr):Bool return switch (e.expr) 
  {
    case EArray(_,_): true;
    default:          false;
  }
  
  // EBinop( op : Binop, e1 : Expr, e2 : Expr );
  public static function isEBinop (e:Expr):Bool return switch (e.expr) 
  {
    case EBinop(_,_,_): true;
    default:            false;
  }
  
  public static function isEBinopWithOpFilter (e:Expr, opFilter:Binop->Bool):Bool return switch (e.expr) 
  {
    case EBinop(op,_,_): opFilter == null || opFilter(op);
    default:             false;
  }
  
  public static function isEBinopAssign (e:Expr):Bool 
  {
    function isOpAssign (op) return switch (op) 
    {
      case Binop.OpAssign: true;
      default:             false;
    }
    
    return isEBinopWithOpFilter(e, isOpAssign);
  }
  
  
  // EField( e : Expr, field : String );
  public static function isEField (e:Expr):Bool return switch (e.expr) 
  {
    case EField(_,_): true;
    default:          false;
  }

  
  // EType( e : Expr, field : String );
  public static function isEType (e:Expr, ?fieldFilter:String->Bool):Bool 
  {
    var fieldFilter = fieldFilter.nullGetOrElseConst(function (_) return true);
    
    return switch (e.expr) 
    {
      case EType(_, field): fieldFilter(field);
      default:              false;
    }
  }
  
  // EParenthesis( e : Expr );
  public static function isEParenthesis (e:Expr):Bool return switch (e.expr) 
  {
    case EParenthesis(e): true;
    default:              false;
  }
  
  // EObjectDecl( fields : Array<{ field : String, expr : Expr }> );
  public static function isEObjectDecl (e:Expr):Bool return switch (e.expr) 
  {
    case EType(_):  true;
    default:        false;
  }
  
  //EArrayDecl( values : Array<Expr> );
  public static function isEArrayDecl (e:Expr):Bool return switch (e.expr) 
  {
    case EArrayDecl(_): true;
    default:            false;
  }
  
	//ECall( e : Expr, params : Array<Expr> );
  public static function isECall (e:Expr):Bool return switch (e.expr) 
  {
    case ECall(_,_): true;
    default:         false;
  }
  
	//ENew( t : TypePath, params : Array<Expr> );
  public static function isENew (e:Expr):Bool 
  {
    return switch (e.expr) 
    {
      case ENew(_,_): true;
      default:        false;
    }
  }
  
	//EUnop( op : Unop, postFix : Bool, e : Expr );
  public static function isEUnop (e:Expr, ?unopFilter:Unop -> Bool):Bool 
  {
    unopFilter = unopFilter.nullGetOrElseConst(Predicates.constTrue1);
    
    return switch (e.expr) 
    {
      case EUnop(op, _, _): unopFilter(op);
      default:              false;
    }
  }
  
  //EVars( vars : Array<{ name : String, type : Null<ComplexType>, expr : Null<Expr> }> );
  public static function isEVars (e:Expr):Bool return switch (e.expr) {
    case EVars(_): true;
    default:       false;
  }
  
  
	//EFunction( name : Null<String>, f : Function );
  public static function isEFunction (e:Expr):Bool return switch (e.expr) 
  {
    case EFunction(_,_):  true;
    default:              false;
  }
  
	//EFor( it : Expr, expr : Expr );
  public static function isEFor (e:Expr):Bool return switch (e.expr) 
  {
    case EFor(_,_): true;
    default:        false;
  }
  
	//EIn( e1 : Expr, e2 : Expr );
  public static function isEIn (e:Expr):Bool return switch (e.expr) 
  {
    case EIn(_,_):  true;
    default:        false;
  }

	//EIf( econd : Expr, eif : Expr, eelse : Null<Expr> );
  public static function isEIf (e:Expr):Bool return switch (e.expr) 
  {
    case EIf(_,_, _):   true;
    default:            false;
  }
  
	//EWhile( econd : Expr, e : Expr, normalWhile : Bool );
  public static function isEWhile (e:Expr):Bool return switch (e.expr) 
  {
    case EWhile(_,_, _): true;
    default:             false;
  }
  
	//ESwitch( e : Expr, cases : Array<{ values : Array<Expr>, expr : Expr }>, edef : Null<Expr> );
  public static function isESwitch (e:Expr):Bool return switch (e.expr) 
  {
    case ESwitch(_,_,_): true;
    default:             false;
  }

	//ETry( e : Expr, catches : Array<{ name : String, type : ComplexType, expr : Expr }> );
  public static function isETry (e:Expr):Bool return switch (e.expr) 
  {
    case ETry(_): true;
    default:      false;
  }

	//EReturn( ?e : Null<Expr> );
  public static function isEReturn (e:Expr):Bool return switch (e.expr) 
  {
    case EReturn(_): true;
    default:         false;
  }
  
	//EBreak;
  public static function isEBreak (e:Expr):Bool return switch (e.expr) 
  {
    case EBreak: true;
    default:     false;
  }

	//EContinue;
  public static function isEContinue (e:Expr):Bool return switch (e.expr) 
  {
    case EContinue: true;
    default:        false;
  }

	//EUntyped( e : Expr );
  public static function isEUntyped (e:Expr):Bool return switch (e.expr) 
  {
    case EUntyped(_): true;
    default:          false;
  }

	//EThrow( e : Expr );
  public static function isEThrow (e:Expr):Bool return switch (e.expr) 
  {
    case EThrow(_): true;
    default:        false;
  }

	//ECast( e : Expr, t : Null<ComplexType> );
  public static function isECast (e:Expr):Bool return switch (e.expr) 
  {
    case ECast(_,_): true;
    default:         false;
  }
  
  //ECast( e : Expr, t : Null<ComplexType> );
  public static function isUnsafeCast (e:Expr):Bool return switch (e.expr) 
  {
    case ECast(_,t): t == null;
    default:         false;
  }

	//EDisplay( e : Expr, isCall : Bool );
  public static function isEDisplay (e:Expr):Bool return switch (e.expr) 
  {
    case EDisplay(_,_): true;
    default:            false;
  }

	//EDisplayNew( t : TypePath );
  public static function isEDisplayNew (e:Expr):Bool return switch (e.expr) 
  {
    case EDisplayNew(_): true;
    default:             false;
  }

	//ETernary( econd : Expr, eif : Expr, eelse : Expr );
  public static function isETernary (e:Expr):Bool return switch (e.expr) 
  {
    case ETernary(_,_,_): true;
    default: false;
  }

  
  // Constant Checks
  public static function isCFloat (c:Constant):Bool return switch (c) 
  {
    case CFloat(_): true;
    default: false;
  }
  
  public static function isCInt (c:Constant):Bool return switch (c) 
  {
    case CInt(_): true;
    default: false;
  }
  
  public static function isCString (c:Constant):Bool return switch (c) 
  {
    case CString(_): true;
    default: false;
  }

  
  public static function isCRegexp (c:Constant):Bool return switch (c) 
  {
    case CRegexp(_, _): true;
    default: false;
  }
  
  public static function isCType (c:Constant):Bool return switch (c) 
  {
    case CType(_): true;
    default: false;
  }
  
  public static function isCIdent (c:Constant):Bool return switch (c) 
  {
    case CIdent(_): true;
    default: false;
  }
}

#end