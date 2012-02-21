package scuts.mcore.extensions;

import haxe.macro.Expr;

class UnopExt 
{

  public static function eq (a:Unop, b:Unop):Bool 
  {
    // haxe really needs pattern matching as a language feature :(
    return switch (a) {
      case OpIncrement: switch (b) { case OpIncrement: true; default: false; };
      case OpDecrement: switch (b) { case OpDecrement: true; default: false; };
      case OpNot:       switch (b) { case OpNot:       true; default: false; };
      case OpNeg:       switch (b) { case OpNeg:       true; default: false; };
      case OpNegBits:   switch (b) { case OpNegBits:   true; default: false; };
     
    }
  }
  
}