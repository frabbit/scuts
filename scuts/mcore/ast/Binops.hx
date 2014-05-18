package scuts.mcore.ast;

#if macro

import haxe.macro.Expr;

class Binops 
{

  public static function eq (a:Binop, b:Binop):Bool 
  {
    // haxe really needs pattern matching as a language feature :(
    return switch [a,b] {
      case [OpArrow, OpArrow]: true;
      case [OpAdd, OpAdd]: true;
      case [OpMult, OpMult]: true;
      case [OpDiv, OpDiv]: true;
      case [OpSub, OpSub]: true;
      case [OpAssign, OpAssign]: true;
      case [OpEq, OpEq]: true;
      case [OpNotEq, OpNotEq]: true;
      case [OpGt, OpGt]: true;
      case [OpGte, OpGte]: true;
      case [OpLt, OpLt]: true;
      case [OpLte, OpLte]: true;
      case [OpAnd, OpAnd]: true;
      case [OpOr, OpOr]: true;
      case [OpXor, OpXor]: true;
      case [OpBoolAnd, OpBoolAnd]: true;
      case [OpBoolOr, OpBoolOr]: true;
      case [OpShl, OpShl]: true;
      case [OpShr, OpShr]: true;
      case [OpUShr, OpUShr]: true;
      case [OpMod, OpMod]: true;
      case [OpInterval, OpInterval]: true;
      case [OpAssignOp(op1), OpAssignOp(op2)] if (eq(op1, op2)): true;
      case _ : false;
    }
  }
  
}

#end