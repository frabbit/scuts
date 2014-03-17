package scuts.ht.macros.syntax;

#if macro

import haxe.macro.Expr;
import scuts.core.Options;
import scuts.core.Validations;

enum FlatMapExpr {
	FMIdents(idents:Array<String>);
	FMExtractor(e:Expr);
}

/**
 * The abstract Datatype of a Do-Operation.
 */
enum DoOp 
{
  OpFilter(expr:Expr, op:DoOp); // Filters are only available in Conjunction with MonadZero.
  OpFlatMap(fe:FlatMapExpr, val:Expr, op:DoOp);
  OpPure(e:Expr, op:Option<DoOp>);
  OpLast(op:DoOp); // special care for last statement, use map if its a pure statement, flatMap otherwise
  OpExpr(e:Expr);
}

/**
 * Possible Errors occuring while Expression Generation.
 */
enum DoGenError 
{
  FilterOnlyAvailableForMonadZeros;
  FilterNotAllowedAtThisPosition;
  PureNotAllowedAtThisPosition;
}
/**
 * Possible Parser Errors.
 */
enum DoParseError {
  LeftSideOfFlatMapMustBeConstIdent;
}
typedef DoParseResult = Validation<DoParseError, DoOp>;

typedef DoGenResult = Validation<DoGenError, Expr>;

#end