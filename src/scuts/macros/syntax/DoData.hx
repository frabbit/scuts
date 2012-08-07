package scuts.macros.syntax;

import haxe.macro.Expr;
import scuts.core.types.Option;
import scuts.core.types.Validation;

/**
 * All Operation types of a Do-Block.
 */
enum DoOp 
{
  OpFilter(expr:Expr, op:DoOp);
  OpFlatMapOrMap(ident:String, val:Expr, op:DoOp);
  OpReturn(e:Expr, op:Option<DoOp>);
  OpLast(op:DoOp); // special care for last statement, use map if its a return statement, flatMap otherwise
  OpExpr(e:Expr);
}

/**
 * Possible Errors occuring while Expression Generation.
 */
enum DoGenError 
{
  NeitherFilterNorWithFilterInScope(val:Expr);
  FilterNotAllowedAtThisPosition;
  ReturnNotAllowedAtThisPosition;
}

enum DoParseError {
  LeftSideOfFlatmapMustBeConstIdent;
}
typedef DoParseResult = Validation<DoParseError, DoOp>;

typedef DoGenResult = Validation<DoGenError, Expr>;
