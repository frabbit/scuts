package scuts.mcore.ast;

#if macro

import haxe.macro.Expr;

class Unops 
{

  public static function eq (a:Unop, b:Unop):Bool return switch [a,b] 
  {
    case [OpIncrement, OpIncrement]: true;
    case [OpDecrement, OpDecrement]: true;
    case [OpNot, OpNot]: true;
    case [OpNeg, OpNeg]: true;
    case [OpNegBits, OpNegBits]: true;
    case _ : false;
  }
  
}

#end