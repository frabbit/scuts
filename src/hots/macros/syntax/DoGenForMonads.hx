package hots.macros.syntax;


import hots.macros.utils.Utils;
import scuts.core.types.Option;
import scuts.macros.syntax.DoParser;
import scuts.macros.syntax.DoTools;
import scuts.mcore.Cast;
import scuts.mcore.extensions.Types;
import scuts.mcore.MContext;
import scuts.mcore.MType;
import haxe.macro.Context;
import scuts.core.types.Tup2;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.mcore.Check;
import haxe.macro.Expr;
import scuts.mcore.Select;

import scuts.macros.Do;

import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.Print;
import scuts.mcore.Check;
import haxe.macro.Expr;
import scuts.mcore.Select;
import scuts.Scuts;
import scuts.macros.syntax.DoData;

using scuts.mcore.Check;
using scuts.mcore.extensions.Exprs;
using scuts.core.extensions.Arrays;
using scuts.core.extensions.Options;

using scuts.macros.syntax.DoTools;
using scuts.core.extensions.Functions;

using scuts.core.extensions.Validations;

class DoGenForMonads
{

  public static function runDo1 <M>(monad:ExprRequire<hots.classes.Monad<M>>, exprs:Array<Expr>) 
  {
    
    var last = exprs.last();
    var head = exprs.removeLast();
    
    // monad zero supports filtering, allows filter expressions in do syntax
    var isMonadZero = 
    {
      function isTypeable (x) 
      {
        // check if monad is also a monadZero, this is the case if upcasting is possible.
        var testForZero = "{ var m : " + Print.type(x) + " = null; var mz : hots.classes.MonadZero<Dynamic> = m; mz;}";
        
        return MContext.isTypeable(Context.parse(testForZero, Context.currentPos()));
      }
      
      MContext.typeof(monad).map(isTypeable).getOrElseConst(false);
    }

    var toExpr = doOpToExpr.partial3(isMonadZero);
    function handleErr (err) return DoParseErrors.handleError(err);
    
    // check if the passed monad is a const ident. 
    // If yes, we don't need to initialize a variable before creating the resulting expression.
    var res = if (monad.isConstIdent()) 
    {
      var op = DoParser.parseExprs(exprs);
      op.map(toExpr.partial2(monad)).getOrElse(handleErr);
    } 
    else 
    {
      var op = DoParser.parseExprs(exprs);
      var e = op.map(toExpr.partial2(macro ___monad)).getOrElse(handleErr);
      
      macro { var ___monad = $monad; $e; };
    }
    #if scutsDebug
    trace("Do-Construct for expression\n" + Print.expr(Make.block(exprs.cons(monad))));
    trace("\n" + Print.expr(res));
    #end
    return res;
  }
  
  
  static function opFlatMapOrMapToExpr (monad:Expr, isMonadZero:Bool, ident:String, val:Expr, op:DoOp) 
  {
    function createFilterExpr (x:Tup2<Expr, DoOp>) 
    {
      if (!isMonadZero) Scuts.error("Using filter in Do Expressions for Monads is only possible if monad is actually a MonadZero");
      var nextFilter = x._2.getFilter();
      
      function createBinaryFilter (y:Tup2<Expr, DoOp>) 
      {
        var newOp = OpFlatMapOrMap(ident, val, OpFilter(x._1.inParenthesis().binopBoolOr(y._1.inParenthesis()), y._2));
        return doOpToExpr(newOp, monad, isMonadZero);
      }
      
      function createElementaryFilter()  
      {
        var thenExpr = x._1;
        // create guard expression
        var ifExpr = Make.ifExpr(x._1, doOpToExpr(x._2, monad, isMonadZero), monad.field("zero").call([])).asReturn();
        
        var newOp = OpFlatMapOrMap(ident, val, OpExpr(ifExpr));
        return doOpToExpr(newOp, monad, isMonadZero);
      }
      
      return nextFilter.map(createBinaryFilter).getOrElse(createElementaryFilter);
    }
    
    function createMapOrFlatMapExpr () 
    {
      var createMap = createMapExpr.partial1_2_3_4(monad, ident, val, op);
      var createFlatMap = createFlatMapExpr.partial1_2_3_4_5(monad, isMonadZero, ident, val, op);
      
      return op.getLastReturnExpr().map(createMap).getOrElse(createFlatMap);
    }
  
    
    
    return op.getFilter().map(createFilterExpr).getOrElse(createMapOrFlatMapExpr);
  }
  
  static function createMapExpr (monad:Expr, ident:String, val:Expr, op:DoOp, x:Expr ):Expr 
  {
    var args = [val, Make.funcExpr([Make.funcArg(ident, false)], x.asReturn())];
    return monad.field("map").call(args);
  }
  
  static function createFlatMapExpr (monad:Expr, isMonadZero:Bool, ident:String, val:Expr, op:DoOp):Expr
  {
    var args = [val, Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(doOpToExpr(op, monad, isMonadZero)))];
    return monad.field("flatMap").call(args);
  }
  
  
  static function opReturnToExpr (monad:Expr, isMonadZero:Bool, e:Expr, optionOp:Option<DoOp>):Expr 
  {
    function createPureExpr () return monad.field("pure").call([e]);
        
    function createMapOrFlatmapWithReturnExpr (op:DoOp) 
    {
      return doOpToExpr(OpFlatMapOrMap("_", createPureExpr() , op), monad, isMonadZero);
    }
    
    return optionOp.map(createMapOrFlatmapWithReturnExpr).getOrElse(createPureExpr);
        
  }
  
  static public function doOpToExpr(op:DoOp, monad:Expr, isMonadZero:Bool):Expr 
  {
    return switch (op) 
    {
      case OpFilter(e, op): 
        Scuts.unexpected();      
      case OpFlatMapOrMap(ident, val, op):  
        opFlatMapOrMapToExpr(monad, isMonadZero, ident, val, op);
      case OpReturn(e, optionOp): 
        opReturnToExpr(monad, isMonadZero, e, optionOp);
      case OpLast(op): 
        doOpToExpr(op, monad, isMonadZero);
      case OpExpr(e): 
        e;
    }
  }

}