package hots.macros.syntax;

#if macro

import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.core.types.Option;
import scuts.core.types.Validation;

import hots.macros.syntax.DoParser;
import scuts.mcore.Make;
import scuts.mcore.Print;
import haxe.macro.Expr;

import scuts.Scuts;

import hots.macros.syntax.DoData;

using scuts.core.extensions.Arrays;
using scuts.core.extensions.Options;
using scuts.core.extensions.Validations;

using hots.macros.syntax.DoTools;
using scuts.mcore.extensions.Exprs;
using scuts.mcore.extensions.Constants;

class DoParser 
{
  /**
  * Creates an abstract Syntax Tree from Haxe Expressions.
  */
  public static function parseExprs (exprs:Array<Expr>):DoParseResult 
  {
    var last = exprs[exprs.length -1];
    var head = exprs.removeLast();
    
    var lastIndex = exprs.length-1;
    
    function convertLast (expr:Expr):DoOp 
    {
      function getOpPure (t:Tup2<Expr, Array<Expr>>) {
        return t._1.selectEConstCIdentValue()
          .filter(function (x) return x == "pure")
          .map   (function (_) return OpLast(OpPure(t._2[0], None)));
      }
      var asCall = expr.selectECall();
      return asCall.flatMap(getOpPure).getOrElse(function () return OpLast(OpExpr(expr)));
    }
    
    function composeToDoOp (cur:Expr, acc1:DoParseResult):DoParseResult 
    {
      function convert (acc:DoOp):DoParseResult 
      {
        function doDefault () {
          return OpFlatMap("_", cur, acc);
        }
        return switch (cur.expr) 
        {
          case EBinop(op,l,r): 
            if (op == OpLte) 
            {
              l.selectEConstCIdentValue()
              .map      (function (x) return OpFlatMap(x, r, acc).toSuccess())
              .getOrElse(LeftSideOfFlatMapMustBeConstIdent.toFailure);
            }
            else OpExpr(cur).toSuccess();
          
          case ECall(expr, params): 
            var asIdent = expr.selectEConstCIdentValue();
            asIdent
            .filter   (function (x) return x == "filter")
            .map      (function (_) return OpFilter(params[0], acc))
            .orElse(
              function () return asIdent
                .filter(function (x) return x == "pure")
                .map   (function (_) return OpPure(params[0], Some(acc)))
            )
            .getOrElse(doDefault)
            .toSuccess();

          default: doDefault().toSuccess();
        }
      }
      return acc1.flatMap(convert);
    }
    return head.foldRight(convertLast(last).toSuccess(), composeToDoOp);
  }

}


#end