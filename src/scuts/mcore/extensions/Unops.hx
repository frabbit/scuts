package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;

class Unops 
{

  public static function eq (a:Unop, b:Unop):Bool return switch a 
  {
    case OpIncrement: switch b { case OpIncrement: true; default: false; };
    case OpDecrement: switch b { case OpDecrement: true; default: false; };
    case OpNot:       switch b { case OpNot:       true; default: false; };
    case OpNeg:       switch b { case OpNeg:       true; default: false; };
    case OpNegBits:   switch b { case OpNegBits:   true; default: false; };
  }
  
}

#end