package scuts.macros.syntax;



import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.core.types.Validation;

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
using scuts.core.extensions.Functions;
using scuts.core.extensions.Validations;

typedef M = scuts.mcore.Make;


class DoGen 
{
  static function createFilter (ident:String, val:Expr, op:DoOp, x:Tup2<Expr, DoOp>):DoGenResult 
  {
    function createBinaryFilter (nextOp:Tup2<Expr, DoOp>) 
    {
      var binaryFilter = 
        OpFilter(
          x._1.inParenthesis()
          .binopBoolAnd(nextOp._1.inParenthesis()),
          nextOp._2
        );
      // create a temporary Do operation with this combined filter and 
      // convert it into an expression
      var newOp = OpFlatMapOrMap(ident, val, binaryFilter);
      return toExpr(newOp);
    }
    
    function createUnaryFilter () 
    {
      function covertFieldToCall (field:Expr) 
      {
        // filterFunc = function (ident) return x._1
        var filterFuncExpr = M.funcExpr([M.funcArg(ident, false)], M.returnExpr(x._1));
        
        // val.filter(filterFunc) or val.withFilter(filterFunc)
        var filterCallExpr = field.call([filterFuncExpr]);
        
        return toExpr(OpFlatMapOrMap(ident, filterCallExpr, x._2));
      }
      
      var withFilterField = val.field("withFilter");
      
      var filterExpr = if (MContext.isTypeable(withFilterField)) 
      {
        withFilterField.toSuccess();
      }
      else 
      {
        var filterField = val.field("filter");
        
        if (MContext.isTypeable(filterField)) filterField.toSuccess()
        else NeitherFilterNorWithFilterInScope(val).toFailure();
      }
      
      return filterExpr.flatMap(covertFieldToCall);
    }

    // if the inner expression of this filter operation is also a filter then
    // combine them to a binary filter like (x > 7 && x < 2). Otherwise create an unary filter like (x > 2).
    var nextFilter = x._2.getFilter();
    return nextFilter.map(createBinaryFilter).getOrElse(createUnaryFilter);
  }
  
  static function createMapOrFlatMapExpr (ident:String, val:Expr, op:DoOp):DoGenResult
  {
    function createMapOrFlatMapExpr ():DoGenResult
    {
      function createFuncArgs () return [M.funcArg(ident, false)];
      function createCallArgs (ret:Expr) return [M.funcExpr(createFuncArgs(), M.returnExpr(ret))];
      
      function createMap (x) return val.field("map").call(createCallArgs(x)).toSuccess();
      
      function createFlatMap () 
      {
        var createCall = function (e:Expr) return val.field("flatMap").call(createCallArgs(e));
        return toExpr(op).map(createCall);
      }
      
      return op.getLastReturnExpr().map(createMap).getOrElse(createFlatMap);
    }
    
    var f = createFilter.partial1_2_3(ident, val, op);
    
    return op.getFilter().map(f).getOrElse(createMapOrFlatMapExpr);
  }
  
  static public function toExpr (op:DoOp):DoGenResult return switch (op) 
  {
    case OpFilter(e, op):                FilterNotAllowedAtThisPosition.toFailure();
    case OpFlatMapOrMap(ident, val, op): createMapOrFlatMapExpr(ident, val, op);
    case OpLast(op):                     toExpr(op);
    case OpReturn(_,_):                  ReturnNotAllowedAtThisPosition.toFailure();
    case OpExpr(e):                      e.toSuccess();
  }
}