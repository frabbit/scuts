package scuts.macros;

#if (macro || display)
import scuts.core.extensions.ArrayExt;
import scuts.core.types.Tup2;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.mcore.Check;
import haxe.macro.Expr;
import scuts.mcore.Select;
import scuts.Scuts;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.OptionExt;
using scuts.mcore.Select;
import scuts.core.types.Option;
enum DoOp {
  OpFilter(expr:Expr, op:DoOp);
  OpFlatMapOrMap(ident:String, val:Expr, op:DoOp);
  
  //OpMap(ident:String, val:Expr, retExpr:Expr);
  OpReturn(e:Expr);
  OpExpr(e:Expr);
}

class DoOps {
  public static function getReturn (op:DoOp):Option<Expr>
  {
    return switch (op) {
      case OpReturn(e):Some(e);
      default: None;
    }
  }
  
  public static function getFilter (op:DoOp):Option<Tup2<Expr, DoOp>>
  {
    return switch (op) {
      case OpFilter(e, op):Some(Tup2.create(e, op));
      default: None;
    }
  }
  
  public static function opToString (o:DoOp):String
  {
    return switch (o) {
      case OpFilter(e, op):            "OpFilter(" + Print.expr(e) + "," + opToString(op) + ")";
      case OpFlatMapOrMap(ident, val, op):  "OpFlatMapOrMap(" + ident + "," + Print.expr(val) + "," + opToString(op) + ")";
      //case OpMap(ident, val, retExpr): "OpMap(" + ident + "," + Print.expr(val) + "," + Print.expr(retExpr) + ")";
      case OpReturn(e):                "OpReturn(" + Print.expr(e) + ")";
      case OpExpr(e):                  "OpExpr(" + Print.expr(e) + ")";
    }
  }
}
using scuts.macros.Do.DoOps;

#end





class Do 
{

  @:macro public static function run<M>(
    e1:Expr, e2:Expr = null, e3:Expr = null, e4:Expr = null,
    e5:Expr = null, e6:Expr = null, e7:Expr = null, e8:Expr = null,
    e9:Expr = null, e10:Expr = null, e11:Expr = null
  )
  {
    var maybeNullExprs = [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11];
    var exprs = maybeNullExprs.filter(function (x) return !Check.isConstNull(x));
    
    var op = exprsToDoOp(exprs);
    trace(op.opToString());
    
    var res = doOpToExpr(op);

    
    
    trace(Print.expr(res));
    
    return res;
  }
  
  
  #if (macro || display)
  
  static public function doOpToExpr(op:DoOp) 
  {
    return switch (op) {
      case OpFilter(e, op): Scuts.unexpected();       
      case OpFlatMapOrMap(ident, val, op):  
        op.getFilter().map(function (x) {
          var nextFilter = x._2.getFilter();
          return nextFilter.map(function (y) {
            var newOp = OpFlatMapOrMap(ident, val, OpFilter(x._1.inParenthesis().binopBoolOr(y._1.inParenthesis()), y._2));
            return doOpToExpr(newOp);
          }).getOrElse(function () return 
          {
            var filterCall = 
              val
              .field("filter")
              .call([Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(x._1))]);
            return doOpToExpr(OpFlatMapOrMap(ident, filterCall, x._2));
          });
        })
        .getOrElse(function () {
          var isRet = op.getReturn();
          return op.getReturn().map(function (x)
            return val.field("map").call([Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(x))])
          ).getOrElse(function ()
            return val.field("flatMap").call([Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(doOpToExpr(op)))])
          );
        });
      //case OpMap(ident, val, retExpr): val.field("map").call([Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(retExpr))]);
      case OpReturn(e): Scuts.unexpected();
      case OpExpr(e): e;
    }
  }
  
  public static function exprsToDoOp (exprs:Array<Expr>) {
    
    var last = exprs[exprs.length -1];
    var head = exprs.removeLast();
    
    var lastIndex = exprs.length-1;
    
    function convertLast (e:Expr):DoOp {
      
      return switch (e.expr) {
        case EReturn(ex): OpReturn(ex);
        default: OpExpr(e);
      }
      
    }
    
    return head.foldRight(function (cur:Expr, acc:DoOp) {
      
      
      return switch (cur.expr) 
      {
        case EBinop(op,l,r): 
          if (op == OpLte) {
            OpFlatMapOrMap(l.selectEConstCIdentValue()
              .getOrError("Left side of flatMap must be const ident"), r, acc);
          }
          else OpExpr(cur);
        case ECall(expr, params): 
          expr.selectEConstCIdentValue().filter(function (x) return x == "filter")
          .map(function (x) return OpFilter(params[0], acc))
          .getOrElse(function () return 
            OpFlatMapOrMap("_", cur, acc));
        default:
          OpFlatMapOrMap("_", cur, acc);
      }
    }, convertLast(last));
  }
  #end
}