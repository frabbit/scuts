package scuts.mcore.extensions;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

import haxe.macro.Expr;
import scuts.mcore.Make;

private typedef M = Make;

class ExprExt 
{
  public static inline function eq (e1:Expr, e2:Expr):Bool 
  {
    return PositionExt.eq(e1.pos, e2.pos)
      && ExprDefExt.eq(e1.expr, e2.expr);
  }
  
  
  public static inline function field (def:Expr, field:String, ?pos:Position) return M.field(def, field, pos)
  
  public static inline function call (def:Expr, func:String, params:Array<Expr>, ?pos:Position) return M.call(def, func, params, pos)
  
  public static inline function toBlock (def:Expr, ?pos:Position) return M.block([def], pos)
  
  public static inline function assignOpTo (from:Expr, to:Expr, op:Binop, ?pos:Position) return M.binop(to, from, OpAssignOp(op), pos)
  
  public static inline function assignOpFrom (to:Expr, from:Expr, op:Binop, ?pos:Position) return M.binop(to, from, OpAssignOp(op), pos)
  
  public static inline function assignTo (from:Expr, to:Expr, ?pos:Position) return M.assign(to, from, pos)
  
  public static inline function assignFrom (to:Expr, from:Expr, ?pos:Position) return M.assign(to, from, pos)
  
  public static inline function assignToVar (def:Expr, varName:String, ?type:ComplexType, ?pos:Position) return M.varExpr(varName, type, def, pos)
  
  public static inline function binopPlus (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpAdd, pos)
  
  public static inline function binopBoolAnd (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpBoolAnd, pos)
  
  public static inline function binopBoolOr (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpBoolOr, pos)
  
  public static inline function binop (left:Expr, right:Expr, op:Binop, ?pos:Position) return M.binop(left, right, op, pos)
  
  public static inline function intervalTo (left:Expr, right:Expr, ?pos:Position) return M.binop(left, right, Binop.OpInterval, pos)
  
  public static inline function asForIter (iter:Expr, varName:String, body:Expr, ?pos:Position) return M.forIn(varName, iter, body, pos)
  
  public static inline function asForBody (body:Expr, varName:String, iter:Expr, ?pos:Position) return M.forIn(varName, iter, body, pos)
  
  public static inline function asWhileCondition (cond:Expr, body:Expr, ?pos:Position) return M.whileExpr(cond, body, pos)
  
  public static inline function asIfCondition (cond:Expr, ifExpr:Expr, ?elseExpr:Expr, ?pos:Position) return M.ifExpr(cond, ifExpr, elseExpr, pos)
  
  public static inline function asIfBody (ifExpr:Expr, cond:Expr, ?elseExpr:Expr, ?pos:Position) return M.ifExpr(cond, ifExpr, elseExpr, pos)
  
  public static inline function withParenthesis (e:Expr, ?pos:Position) return M.expr(EParenthesis(e), pos)
  
  
  
  
  
}

#end