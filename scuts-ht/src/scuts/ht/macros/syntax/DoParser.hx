package scuts.ht.macros.syntax;

#if macro

import scuts.core.Arrays;
import scuts.core.Tuples;

import scuts.ht.macros.syntax.DoParser;
import scuts.mcore.Make;
import scuts.mcore.Print;
import haxe.macro.Expr;

import scuts.Scuts;

import scuts.ht.macros.syntax.DoData;

using scuts.core.Arrays;
using scuts.core.Options;
using scuts.core.Validations;

using scuts.ht.macros.syntax.DoTools;
using scuts.mcore.ast.Exprs;
using scuts.mcore.ast.Constants;

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