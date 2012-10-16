package scuts.mcore.extensions;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import scuts.core.macros.Lazy;
import scuts.core.Tup2;
import scuts.mcore.Make;
import scuts.core.Option;
using scuts.core.Options;
using scuts.core.Arrays;
using scuts.core.Dynamics;
private typedef M = Make;

class Exprs 
{
  public static function eq (e1:Expr, e2:Expr):Bool 
  {
    return Positions.eq(e1.pos, e2.pos)
      && ExprDefs.eq(e1.expr, e2.expr);
  }
  
  public static inline function field (def:Expr, field:String, ?pos:Position) return M.field(def, field, pos)
  
  public static inline function fields (def:Expr, fields:Array<String>, ?pos:Position) return M.fields(def, fields, pos)
  
  public static inline function call (e:Expr, params:Array<Expr>, ?pos:Position) return M.call(e, params, pos)
  
  public static inline function toBlock (def:Expr, ?pos:Position) return M.block([def], pos)
  
  public static inline function assignOpTo (from:Expr, to:Expr, op:Binop, ?pos:Position) return M.binop(to, from, OpAssignOp(op), pos)
  
  public static inline function assignOpFrom (to:Expr, from:Expr, op:Binop, ?pos:Position) return M.binop(to, from, OpAssignOp(op), pos)
  
  public static inline function assignTo (from:Expr, to:Expr, ?pos:Position) return M.assign(to, from, pos)
  
  public static inline function assignFrom (to:Expr, from:Expr, ?pos:Position) return M.assign(to, from, pos)
  
  public static inline function assignToVar (def:Expr, varName:String, ?type:ComplexType, ?pos:Position) return M.varExpr(varName, type, def, pos)
  
  public static inline function binopPlus (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpAdd, pos)
  
  public static inline function binopBoolAnd (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpBoolAnd, pos)
  
  public static inline function binopBoolOr (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpBoolOr, pos)
  
  public static inline function binopBoolEq (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpEq, pos)
  
  public static inline function binopBoolNotEq (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpNotEq, pos)
  
  public static inline function binop (left:Expr, right:Expr, op:Binop, ?pos:Position) return M.binop(left, right, op, pos)
  
  public static inline function intervalTo (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpInterval, pos)
  
  public static inline function asForIter (iter:Expr, varName:String, body:Expr, ?pos:Position) return M.forIn(varName, iter, body, pos)
  
  public static inline function asForBody (body:Expr, varName:String, iter:Expr, ?pos:Position) return M.forIn(varName, iter, body, pos)
  
  public static inline function asReturn (e:Expr, ?pos:Position) return M.returnExpr(e, pos)
  
  public static inline function asWhileCondition (cond:Expr, body:Expr, ?pos:Position) return M.whileExpr(cond, body, pos)
  
  public static inline function asIfCondition (cond:Expr, ifExpr:Expr, ?elseExpr:Expr, ?pos:Position) return M.ifExpr(cond, ifExpr, elseExpr, pos)
  
  public static inline function asIfBody (ifExpr:Expr, cond:Expr, ?elseExpr:Expr, ?pos:Position) return M.ifExpr(cond, ifExpr, elseExpr, pos)
  
  public static inline function withParenthesis (e:Expr, ?pos:Position) return M.expr(EParenthesis(e), pos)
  
  public static inline function lazy (e:Expr, ?pos:Position) return Lazy.mkExpr(e)

  public static inline function inParenthesis (e:Expr) return Make.parenthesis(e)
  
  public static function typeof(expr:Expr):Option<haxe.macro.Type>
	{
		return 
      try               Some(Context.typeof(expr))
      catch (e:Dynamic) None;
	}
  
  public static function isTypeable (expr:Expr):Bool return typeof(expr).isSome()
  
  public static function selectECallExpr (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case ECall(e,_): Some(e);
    default: None;
  }
  
  public static function selectEConstConstant (e:Expr):Option<Constant> return switch (e.expr) 
  {
    case EConst(c): c.toOption();
    default: None;
  }
  
  public static function selectEConstCIdentValue (e:Expr):Option<String> 
  {
    return selectEConstConstant(e).flatMap(Constants.selectCIdentValue);
  }
  
  public static function extractBinOpRightExpr (e:Expr, filter:Binop->Bool ):Option<Expr> return switch (e.expr) 
  {
    case EBinop(b, e1, e2): if (filter(b)) Some(e2) else None;
    default:                None;
  }
 
  public static function selectECall (e:Expr):Option<Tup2<Expr, Array<Expr>>> return switch (e.expr) 
  {
    case ECall(call , params): Some(Tup2.create(call, params));
    default: None;
  }

  public static function isUnsafeCast (e:Expr):Bool return switch (e.expr) 
  {
    case ECast(_,t): t == null;
    default:         false;
  }
  
  public static function isConstNull (e:Expr) 
  {
    return isConstIdent(e, function (x) return x == "null");
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
}

#end