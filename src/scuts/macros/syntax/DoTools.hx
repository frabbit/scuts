package scuts.macros.syntax;
import haxe.macro.Expr;
import haxe.PosInfos;
import scuts.core.types.Option;
import scuts.core.types.Tup2;
import scuts.mcore.MContext;
import scuts.mcore.Print;
import scuts.macros.syntax.DoData;
import scuts.Scuts;

using scuts.core.extensions.Options;
using scuts.core.extensions.Arrays;

class DoOps 
{
  /**
   * Returns the corresponding values of a OpReturn operation.
   */
  public static function getReturn (op:DoOp):Option<Tup2<Expr, Option<DoOp>>> return switch (op) 
  {
    case OpReturn(e, op): Some(Tup2.create(e, op));
    default: None;
  }

  
  /**
   * Returns the nested expression inside of an OpReturn operation.
   */
  public static function getLastReturnExpr (op:DoOp):Option<Expr> return switch (op) 
  {
    case OpLast(op): 
      getReturn(op).map(function (x) return x._1);
    default: None;
  }
  
  /**
   * Checks if op is an OpLast operation.
   */
  public static function isLast (op:DoOp):Bool return switch (op) 
  {
    case OpLast(_):true;
    default: false;
  }
  
  
  /**
   * Returns the corresponding values of a OpLast operation.
   */
  public static function getLast (op:DoOp):Option<DoOp> return switch (op) 
  {
    case OpLast(e): Some(e);
    default: None;
  }
  
  /**
   * Returns the corresponding expr of an OpExpr operation, this
   * is the last Operation inside of a Do block and must return a
   * pure value, if not placed inside of a OpReturn operation.
   * 
   */
  public static function getExpr (op:DoOp):Option<Expr> return switch (op) 
  {
    case OpExpr(e): Some(e);
    default: None;
  }
  
  /**
   * Returns the corresponding values of a OpFilter operation.
   * The first argument is the filter expression and the second is
   * the remaining operation.
   */
  public static function getFilter (op:DoOp):Option<Tup2<Expr, DoOp>> return switch (op) 
  {
    case OpFilter(e, op): Some(Tup2.create(e, op));
    default: None;
  }
  /**
   * Converts a DoOp into a string, usually for debugging purposes.
   */
  public static function opToString (o:DoOp):String return switch (o) 
  {
    case OpFilter(e, op):                "OpFilter(" + Print.expr(e) + "," + opToString(op) + ")";
    case OpFlatMapOrMap(ident, val, op): "OpFlatMapOrMap(" + ident + "," + Print.expr(val) + "," + opToString(op) + ")";
    case OpReturn(e, optOp):             "OpReturn(" + Print.expr(e) + ", " + optOp.toString(opToString) + ")";
    case OpExpr(e):                      "OpExpr(" + Print.expr(e) + ")";
    case OpLast(op):                     "OpLast(" + opToString(op) + ")";
  }
}

class DoGenErrors 
{
  /**
   * Converts a generator error into a String.
   */
  public static function toString (err:DoGenError) return switch (err) 
  {
    case  NeitherFilterNorWithFilterInScope(val):
      var typeStr = MContext.typeof(val).map(function (x) return Print.type(x)).getOrElseConst("(Not Typeable)");
      "Neither function withFilter nor filter is not in scope for type " + typeStr;
    case FilterNotAllowedAtThisPosition:
      "It's not allowed to use filter here";
    case ReturnNotAllowedAtThisPosition:
      "It's not allowed to use return here";
  }

  /**
   * Throws an Error with an appropriate message for the generator error.
   */
  public static function handleError <T>(err:DoGenError, ?position:Position, ?infos:PosInfos):T 
  {
    return Scuts.macroError(toString(err), position, infos);
  }
}

class DoParseErrors 
{
  /**
   * Converts a parser error into a String.
   */
  public static function toString (err:DoParseError) return switch (err) 
  {
    case LeftSideOfFlatmapMustBeConstIdent: 
      "The left side of the flatmap '<=' operation must be a constant identifier";
  }

  /**
   * Throws an Error with an appropriate message for the parser error.
   */
  public static function handleError <T>(err:DoParseError, ?position:Position, ?infos:PosInfos):T 
  {
    return Scuts.macroError(toString(err), position, infos);
  }
}