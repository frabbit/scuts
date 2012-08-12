package scuts.macros.syntax;

#if macro

import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.macros.syntax.DoParser;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.Print;
import scuts.mcore.Check;
import haxe.macro.Expr;
import scuts.mcore.Select;
import scuts.Scuts;
using scuts.mcore.extensions.Exprs;
using scuts.core.extensions.Arrays;
using scuts.core.extensions.Options;
using scuts.mcore.Select;
import scuts.core.types.Option;

import scuts.macros.syntax.DoData;

using scuts.macros.syntax.DoTools;

import scuts.core.types.Validation;
using scuts.core.extensions.Validations;
#end




class DoParser 
{

  public static function parseExprs (exprs:Array<Expr>):DoParseResult 
  {
    var last = exprs[exprs.length -1];
    var head = exprs.removeLast();
    
    var lastIndex = exprs.length-1;
    
    function convertLast (e:Expr):DoOp return switch (e.expr) 
    {
      case EReturn(ex): OpLast(OpReturn(ex, None));
      default: OpLast(OpExpr(e));
    }
    
    function composeToDoOp (cur:Expr, acc1:DoParseResult):DoParseResult 
    {
      function convert (acc:DoOp):DoParseResult return switch (cur.expr) 
      {
        case EBinop(op,l,r): 
          if (op == OpLte) 
          {
            l.selectEConstCIdentValue()
            .map      (function (x) return OpFlatMapOrMap(x, r, acc).toSuccess())
            .getOrElse(LeftSideOfFlatmapMustBeConstIdent.toFailure);
          }
          else OpExpr(cur).toSuccess();
        
        case ECall(expr, params): 
          
          expr.selectEConstCIdentValue()
          .filter   (function (x) return x == "filter")
          .map      (function (x) return OpFilter(params[0], acc))
          .getOrElse(function ()  return OpFlatMapOrMap("_", cur, acc))
          .toSuccess();
        
        case EReturn(expr):
          OpReturn(expr, Some(acc)).toSuccess();
        default:
          OpFlatMapOrMap("_", cur, acc).toSuccess();
      }
      return acc1.flatMap(convert);
    }
    return head.foldRight(composeToDoOp, convertLast(last).toSuccess());
  }
  
  
  
}