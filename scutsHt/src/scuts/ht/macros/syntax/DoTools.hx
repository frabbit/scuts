package scuts.ht.macros.syntax;

#if macro

import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.PosInfos;
import scuts.ht.macros.implicits.Cache;
import scuts.ht.macros.implicits.Caches;
import scuts.ht.macros.implicits.Resolver;
import scuts.ht.macros.implicits.Tools;

import scuts.core.Tuples;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.ht.macros.syntax.DoData;
import scuts.Scuts;

using scuts.core.Options;
using scuts.core.Arrays;

using scuts.mcore.ast.Exprs;
using scuts.core.Functions;
using scuts.core.Validations;

class DoTools {
  
  static var helper(default, null) = macro scuts.ht.macros.syntax.DoHelper;
  
  /**
   * Create an Expr returning a Monad Syntax, based on the type of the Expr expr.
   * 
   */


  public static function getMonadExpr (expr:Expr, zero:Bool):Expr
  {

    return try 
    {
      var x = if (zero) macro $helper.getMonadEmpty($expr) else macro $helper.getMonad($expr);

      Resolver.resolveImplicitObj(x);
    } 
    catch (e:Error) 
    {
      var id = if (zero) "MonadEmpty (required for filter) " else "Monad";
      Scuts.warning("Do-Comprehension build error", 
        "No " + id + " instance in scope for expr " + Tools.prettyExpr(expr) + " of Type " + Tools.prettyTypeOfExpr(expr));
    }
  }

  /**
   * Checks if the expressions of a Do-Operation actually require a MonadZero-Instance.
   */
  static function requiresMonadEmpty (exprs:Array<Expr>) 
  {
    return exprs.any(function (e) 
    {
      return switch (e.selectECallExpr().flatMap(Exprs.selectEConstCIdentValue)) 
      {
        case Some(ident): return ident == "filter";
        case None : false;
      }
    });
  }

  

  /**
   * build is the actual user-interface for building Do-Operations, it takes an 
   * Array of Expressions parses it and generates a haxe expression out of monadic
   * operations.
   */
  public static function build (exprs:Array<Expr>) 
  {

    var id = Context.signature(exprs);
    if (Caches.doCache.exists(id)) return Caches.doCache.get(id);
    
    var res = if (exprs.length > 0) 
    {
      var e = exprs[0];
      var o = e.extractBinOpRightExpr(function (b) return b == Binop.OpLte).getOrElseConst(e);
      //var upcast = try Tup2.create(Resolver.applyImplicitUpcast(o, false, true), true) catch (e:Error) Tup2.create(o, false);
      
      
      var isZero = requiresMonadEmpty(exprs);
      var monadExpr = getMonadExpr(o, isZero);
      
      var res = buildWithMonad(monadExpr, exprs, false, isZero);
      //Resolver.applyImplicitDowncast(res, true);
      res;
    } 
    else 
    {
      Scuts.error("Invalid Do-Syntax - You have to provide at least one Expression");
    }
    Caches.doCache.set(id, res);
    return res;
  }
  
  public static function buildWithMonad <M>(monad:ExprOf<scuts.ht.classes.Monad<M>>, exprs:Array<Expr>, isUpcasted:Bool, isMonadZero:Bool) 
  {
    function handleErr (err) return DoParseErrors.handleError(err);
    
    // partial apply the function doOpToExpr
    var toExpr = DoGen.doOpToExpr.bind(_,_,isMonadZero, isUpcasted);
    
    // check if the passed monad is a const ident. 
    // If yes, we don't need to build a block for the resulting expression.
    var isConstIdent = monad.isConstIdent();
    
    var monadExpr = if (isConstIdent) monad else macro ___monad;
    
    // parse to abstract syntax tree
    var ast = DoParser.parseExprs(exprs);
    
    // generate resulting expression
    var generated = ast.map(toExpr.bind(_, monadExpr)).getOrElse(handleErr);
    
    var res = if (isConstIdent) generated else macro { var ___monad = $monad; $generated; }
    
    
    #if scutsDebug
    trace("Do-Construct for expression\n" + Print.expr(Make.block(exprs.cons(monad))));
    trace("\n" + Print.expr(res));
    #end
    return res;
  }
}

class DoOps 
{
  /**
   * Returns the corresponding values of a OpReturn operation.
   */
  public static function getPure (op:DoOp):Option<Tup2<Expr, Option<DoOp>>> return switch (op) 
  {
    case OpPure(e, op): Some(Tup2.create(e, op));
    default: None;
  }

  
  /**
   * Returns the nested expression inside of an OpReturn operation.
   */
  public static function getLastPureExpr (op:DoOp):Option<Expr> return switch (op) 
  {
    case OpLast(op): 
      getPure(op).map(function (x) return x._1);
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
    case OpFlatMap(ident, val, op):      "OpFlatMap(" + ident + "," + Print.expr(val) + "," + opToString(op) + ")";
    case OpPure(e, optOp):               "OpPure(" + Print.expr(e) + ", " + optOp.toString(opToString) + ")";
    case OpExpr(e):                      "OpExpr(" + Print.expr(e) + ")";
    case OpLast(op):                     "OpLast(" + opToString(op) + ")";
  }
}

class DoGenErrors 
{
  /**
   * Converts a generator error into a more helpful String.
   */
  public static function toString (err:DoGenError) return switch (err) 
  {
    case  FilterOnlyAvailableForMonadZeros:
      "Filter can only be used if a MonadZero is in Scope";
    case FilterNotAllowedAtThisPosition:
      "It's not allowed to use filter here";
    case PureNotAllowedAtThisPosition:
      "It's not allowed to use pure here";
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
    case LeftSideOfFlatMapMustBeConstIdent: 
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

#end