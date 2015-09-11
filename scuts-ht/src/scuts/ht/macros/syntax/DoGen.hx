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

import scuts.ht.macros.implicits.Tools;

import haxe.macro.Context;
import haxe.macro.Expr;

import scuts.ht.macros.syntax.DoData;

using scuts.mcore.ast.Exprs;

using scuts.core.Arrays;
using scuts.core.Options;
using scuts.core.Functions;
using scuts.core.Validations;

using scuts.ht.macros.syntax.DoTools;



class DoGen
{

  /*
   * Converts a do-Operation into a Haxe-Expr.
   */
  public static function doOpToExpr(op:DoOp, monad:Expr, isMonadZero:Bool, isUpcasted:Bool):Expr return switch (op)
  {
    case OpFilter(_, _):           Scuts.unexpected();
    case OpFlatMap(idents, val, op): opFlatMapToExpr(monad, isMonadZero, isUpcasted, idents, val, op);
    case OpPure(e, optionOp):       opPureToExpr(monad, isMonadZero, isUpcasted, e, optionOp);
    case OpLast(op):                doOpToExpr(op, monad, isMonadZero, isUpcasted);
    case OpExpr(e):                 e;
  }

  // internal functions

  /**
   * Converts a OpFlatMap Expression into an Expr
   */
  static function opFlatMapToExpr (monad:Expr, isMonadZero:Bool, isUpcasted:Bool, idents:FlatMapExpr, val:Expr, op:DoOp)
  {
    function createFilterExpr (x:Tup2<Expr, DoOp>)
    {
      if (!isMonadZero) Scuts.error("Using filter in Do Expressions for Monads is only possible if monad is actually a MonadZero");
      var nextFilter = x._2.getFilter();

      function createBinaryFilter (y:Tup2<Expr, DoOp>)
      {
        var newOp = OpFlatMap(idents, val, OpFilter(x._1.inParenthesis().binopBoolAnd(y._1.inParenthesis()), y._2));
        return doOpToExpr(newOp, monad, isMonadZero, isUpcasted);
      }

      function createElementaryFilter()
      {
        var thenExpr = x._1;
        // create guard expression
        var ifExpr = Make.ifExpr(x._1, doOpToExpr(x._2, monad, isMonadZero, isUpcasted), monad.field("empty").call([]));

        var newOp = OpFlatMap(idents, val, OpExpr(ifExpr));
        return doOpToExpr(newOp, monad, isMonadZero, isUpcasted);
      }

      return nextFilter.map(createBinaryFilter).getOrElse(createElementaryFilter);
    }

    function createMapOrFlatMapExpr ()
    {
      var createMap = function (x) return createMapExpr(monad, isUpcasted, idents, val, op,x);
      var createFlatMap = function () return createFlatMapExpr(monad, isMonadZero, isUpcasted, idents, val, op);


      return op.getLastPureExpr().map(createMap).getOrElse(createFlatMap);
    }

    return op.getFilter().map(createFilterExpr).getOrElse(createMapOrFlatMapExpr);
  }


  /**
   * Creates a map-Expr with the inner expression op. (map are used for optimization).
   */
  static function createMapExpr (monad:Expr, isUpcasted:Bool, fmExpr:FlatMapExpr, val:Expr, op:DoOp, x:Expr ):Expr
  {
    var e = isUpcasted ? macro $val.implicitUpcast() : val;
    var args = switch (fmExpr) {
      case FMIdents(idents): [e, Make.funcExpr([Make.funcArg(idents[0], false)], x.asReturn())];
      case _ : throw "not implemented";
    }
    return monad.field("map").call(args);
  }

  /**
   * Creates a flatMap-Expr without Filter with the inner expression represented by op.
   */
  static function createFlatMapExpr (monad:Expr, isMonadZero:Bool, isUpcasted:Bool, fmExpr:FlatMapExpr, val:Expr, op:DoOp):Expr
  {
    // maybe upcasting
    var e = isUpcasted ? macro @:pos(val.pos) $val.implicitUpcast() : val;



    var f = switch (fmExpr) {
      case FMIdents(idents):
        var exprs = switch (idents.length) {
          case 0 : [];
          case 1 :
            var name = idents[0];
            [macro @:pos(val.pos) var $name = _fm_res];
          case _ : idents.mapWithIndex(function (e, index) {
            var index = "_"+(index+1);
            var ex = macro @:pos(val.pos) var $e = _fm_res.$index;

            return ex;
          });


        }
        var resExpr = macro return ${doOpToExpr(op, monad, isMonadZero, isUpcasted)};

        macro @:pos(val.pos) function (_fm_res) $b{exprs.concat([resExpr])}
      case FMExtractor(x) : // extractor expression
        macro @:pos(val.pos) function (_fm_res) return switch (_fm_res) {
      case $x : ${doOpToExpr(op, monad, isMonadZero, isUpcasted)};
        }
    }







    var args = [e, f];

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
        default: doOpToExpr(OpFlatMap(FMIdents(["_"]), createPureExpr() , op), monad, isMonadZero, isUpcasted);
      }
    }

    return optionOp.map(createMapOrFlatmapWithPureExpr).getOrElse(createPureExpr);
  }

}

#end