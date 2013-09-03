package scuts.ht.macros.syntax;

#if macro


import scuts.ht.macros.implicits.Manager;
import scuts.Scuts;

import scuts.core.Options;
import scuts.core.Tuples;
import scuts.core.Arrays;

import scuts.mcore.ast.Types;
import scuts.mcore.ast.Exprs;
import scuts.mcore.Make;
import scuts.mcore.Print;

import scuts.ht.macros.implicits.Resolver;
import scuts.ht.macros.syntax.DoParser;
import scuts.ht.macros.syntax.RealDoTools;

import scuts.ht.macros.implicits.Tools;

import haxe.macro.Context;
import haxe.macro.Expr;

import scuts.ht.macros.syntax.DoData;

using scuts.mcore.ast.Exprs;

using scuts.core.Arrays;
using scuts.core.Options;
using scuts.core.Functions;
using scuts.core.Validations;

using scuts.ht.macros.syntax.RealDoTools;



class DoGen
{
  
  /*
   * Converts a do-Operation into a Haxe-Expr.
   */
  public static function doOpToExpr(op:DoOp, monad:Expr, isMonadZero:Bool, isUpcasted:Bool):Expr return switch (op) 
  {
    case OpFilter(_, _):           Scuts.unexpected();      
    case OpFlatMap(ident, val, op): opFlatMapToExpr(monad, isMonadZero, isUpcasted, ident, val, op);
    case OpPure(e, optionOp):       opPureToExpr(monad, isMonadZero, isUpcasted, e, optionOp);
    case OpLast(op):                doOpToExpr(op, monad, isMonadZero, isUpcasted);
    case OpExpr(e):                 e;
  }
  
  // internal functions
  
  /**
   * Converts a OpFlatMap Expression into an Expr 
   */
  static function opFlatMapToExpr (monad:Expr, isMonadZero:Bool, isUpcasted:Bool, ident:String, val:Expr, op:DoOp) 
  {
    function createFilterExpr (x:Tup2<Expr, DoOp>) 
    {
      if (!isMonadZero) Scuts.error("Using filter in Do Expressions for Monads is only possible if monad is actually a MonadZero");
      var nextFilter = x._2.getFilter();
      
      function createBinaryFilter (y:Tup2<Expr, DoOp>) 
      {
        var newOp = OpFlatMap(ident, val, OpFilter(x._1.inParenthesis().binopBoolAnd(y._1.inParenthesis()), y._2));
        return doOpToExpr(newOp, monad, isMonadZero, isUpcasted);
      }
      
      function createElementaryFilter()  
      {
        var thenExpr = x._1;
        // create guard expression
        var ifExpr = Make.ifExpr(x._1, doOpToExpr(x._2, monad, isMonadZero, isUpcasted), monad.field("empty").call([]));
        
        var newOp = OpFlatMap(ident, val, OpExpr(ifExpr));
        return doOpToExpr(newOp, monad, isMonadZero, isUpcasted);
      }
      
      return nextFilter.map(createBinaryFilter).getOrElse(createElementaryFilter);
    }
    
    function createMapOrFlatMapExpr () 
    {
      var createMap = function (x) return createMapExpr(monad, isUpcasted, ident, val, op,x);
      var createFlatMap = function () return createFlatMapExpr(monad, isMonadZero, isUpcasted, ident, val, op);
      
      
      return op.getLastPureExpr().map(createMap).getOrElse(createFlatMap);
    }

    return op.getFilter().map(createFilterExpr).getOrElse(createMapOrFlatMapExpr);
  }
  
  
  /**
   * Creates a map-Expr with the inner expression op. (map are used for optimization).
   */
  static function createMapExpr (monad:Expr, isUpcasted:Bool, ident:String, val:Expr, op:DoOp, x:Expr ):Expr 
  {
    var e = isUpcasted ? macro $val.implicitUpcast() : val;
    var args = [e, Make.funcExpr([Make.funcArg(ident, false)], x.asReturn())];
    return monad.field("map").call(args);
  }
  
  /**
   * Creates a flatMap-Expr without Filter with the inner expression represented by op.
   */
  static function createFlatMapExpr (monad:Expr, isMonadZero:Bool, isUpcasted:Bool, ident:String, val:Expr, op:DoOp):Expr
  {
    // maybe upcasting
    var e = isUpcasted ? macro $val.implicitUpcast() : val;
    var args = [e, Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(doOpToExpr(op, monad, isMonadZero, isUpcasted)))];
    return monad.field("flatMap").call(args);
  }

  /**
   * Converts an abstract PureOperation into a haxe Expression
   */
  static function opPureToExpr (monad:Expr, isUpcasted:Bool, isMonadZero:Bool, e:Expr, optionOp:Option<DoOp>):Expr 
  {
    function createPureExpr () {
      return monad.field("pure").call([e]);
    }
    function createMapOrFlatmapWithPureExpr (op:DoOp) 
    {
      return switch (op) {
        
        case OpFlatMap(x, val, op2): createMapExpr(monad, isUpcasted, x, val, op2,  e);
        default: doOpToExpr(OpFlatMap("_", createPureExpr() , op), monad, isMonadZero, isUpcasted);
      }
    }

    return optionOp.map(createMapOrFlatmapWithPureExpr).getOrElse(createPureExpr);
  }

}

#end