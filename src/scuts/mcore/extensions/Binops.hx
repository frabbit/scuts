package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;

class Binops 
{

  public static function eq (a:Binop, b:Binop):Bool 
  {
    // haxe really needs pattern matching as a language feature :(
    return switch (a) {
      case OpAdd:           switch (b) { case OpAdd:           true;         default: false; };
      case OpMult:          switch (b) { case OpMult:          true;         default: false; };
      case OpDiv:           switch (b) { case OpDiv:           true;         default: false; };
      case OpSub:           switch (b) { case OpSub:           true;         default: false; };
      case OpAssign:        switch (b) { case OpAssign:        true;         default: false; };
      case OpEq:            switch (b) { case OpEq:            true;         default: false; };
      case OpNotEq:         switch (b) { case OpNotEq:         true;         default: false; };
      case OpGt:            switch (b) { case OpGt:            true;         default: false; };
      case OpGte:           switch (b) { case OpGte:           true;         default: false; };
      case OpLt:            switch (b) { case OpLt:            true;         default: false; };
      case OpLte:           switch (b) { case OpLte:           true;         default: false; };
      case OpAnd:           switch (b) { case OpAnd:           true;         default: false; };
      case OpOr:            switch (b) { case OpOr:            true;         default: false; };
      case OpXor:           switch (b) { case OpXor:           true;         default: false; };
      case OpBoolAnd:       switch (b) { case OpBoolAnd:       true;         default: false; };
      case OpBoolOr:        switch (b) { case OpBoolOr:        true;         default: false; };
      case OpShl:           switch (b) { case OpShl:           true;         default: false; };
      case OpShr:           switch (b) { case OpShr:           true;         default: false; };
      case OpUShr:          switch (b) { case OpUShr:          true;         default: false; };
      case OpMod:           switch (b) { case OpMod:           true;         default: false; };
      case OpAssignOp(op1): switch (b) { case OpAssignOp(op2): eq(op1, op2); default: false; };
      case OpInterval:      switch (b) { case OpInterval:      true;         default: false; };
    }
  }
  
}

#end