package scuts.macros;

#if (macro || display)
import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.Print;
import scuts.mcore.Check;
import haxe.macro.Expr;
import scuts.mcore.Select;
import scuts.Scuts;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.Arrays;
using scuts.core.extensions.Options;
using scuts.mcore.Select;
import scuts.core.types.Option;
enum DoOp {
  OpFilter(expr:Expr, op:DoOp);
  OpFlatMapOrMap(ident:String, val:Expr, op:DoOp);
  OpReturn(e:Expr, op:Option<DoOp>);
  OpLast(op:DoOp); // special care for last statement, use map if its a return statement, flatMap otherwise
  OpExpr(e:Expr);
  //OpLet(vars:{ name : String, value : Expr}, op:DoOp);
}

class DoOps {
  public static function getReturn (op:DoOp):Option<Tup2<Expr, Option<DoOp>>>
  {
    return switch (op) {
      case OpReturn(e, op):Some(Tup2.create(e, op));
      default: None;
    }
  }
  
  public static function getLastReturnExpr (op:DoOp):Option<Expr>
  {
    return switch (op) {
      case OpLast(op): 
        getReturn(op).map(function (x) return x._1);
      default: None;
    }
  }
  public static function isLast (op:DoOp):Bool {
     return switch (op) {
      case OpLast(_):true;
      default: false;
    }
  }
  
  public static function getLast (op:DoOp):Option<DoOp>
  {
    return switch (op) {
      case OpLast(e):Some(e);
      default: None;
    }
  }
  
  public static function getExpr (op:DoOp):Option<Expr>
  {
    return switch (op) {
      case OpExpr(e):Some(e);
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
      case OpFilter(e, op):                "OpFilter(" + Print.expr(e) + "," + opToString(op) + ")";
      case OpFlatMapOrMap(ident, val, op): "OpFlatMapOrMap(" + ident + "," + Print.expr(val) + "," + opToString(op) + ")";
      //case OpMap(ident, val, retExpr): "OpMap(" + ident + "," + Print.expr(val) + "," + Print.expr(retExpr) + ")";
      case OpReturn(e, optOp):                    "OpReturn(" + Print.expr(e) + ", " + optOp.toString(opToString) + ")";
      case OpExpr(e):                      "OpExpr(" + Print.expr(e) + ")";
      case OpLast(op):                     "OpLast(" + opToString(op) + ")";
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
    //trace(op.opToString());
    
    var res = doOpToExpr(op);

    
    
    trace(Print.expr(res));
    
    return res;
  }
  
  
  #if (macro || display)
  
  static public function doOpToExpr(op:DoOp) 
  {
    return switch (op) {
      case OpFilter(e, op): Scuts.error("It's not allowed to use filter here");       
      case OpFlatMapOrMap(ident, val, op):  
        op.getFilter().map(function (x) {
          var nextFilter = x._2.getFilter();
          
          return 
            nextFilter.map(function (y) 
            {
              var newOp = OpFlatMapOrMap(ident, val, OpFilter(x._1.inParenthesis().binopBoolAnd(y._1.inParenthesis()), y._2));
              return doOpToExpr(newOp);
            }).getOrElse(function () return 
            {
              var filterFunc = 
                if (MContext.isTypeable(val.field("withFilter"))) val.field("withFilter") 
                else 
                  if (MContext.isTypeable(val.field("filter"))) val.field("filter")
                  else Scuts.error("Neither function withFilter nor filter is not in scope for type " + MContext.typeof(val).map(function (x) return Print.type(x)).getOrElseConst("(Not Typeable)"));
  
              var filterCall = 
                filterFunc
                .call([Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(x._1))]);
              return doOpToExpr(OpFlatMapOrMap(ident, filterCall, x._2));
            });
        })
        .getOrElse(function () {
          return op.getLastReturnExpr().map(function (x)
            return val.field("map").call([Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(x))])
          ).getOrElse(function ()
            return val.field("flatMap").call([Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(doOpToExpr(op)))])
          );
        });
      case OpLast(op):
        doOpToExpr(op);
      case OpReturn(_,_): Scuts.error("It's not allowed to use return here");
      case OpExpr(e): e;
    }
  }
  
  public static function exprsToDoOp (exprs:Array<Expr>) {
    
    var last = exprs[exprs.length -1];
    var head = exprs.removeLast();
    
    var lastIndex = exprs.length-1;
    
    function convertLast (e:Expr):DoOp {
      
      return switch (e.expr) {
        case EReturn(ex): OpLast(OpReturn(ex, None));
        default: OpLast(OpExpr(e));
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
        case EReturn(expr):
          OpReturn(expr, Some(acc));
        default:
          OpFlatMapOrMap("_", cur, acc);
      }
    }, convertLast(last));
  }
  #end
}