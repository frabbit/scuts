package hots.extensions;
#if !macro
import hots.instances.ArrayOfMonad;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Monad;
#end

#if macro
import scuts.core.types.Tup2;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.mcore.Check;
import haxe.macro.Expr;
import scuts.mcore.Select;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.OptionExt;

#end

/**
 * ...
 * @author 
 */

class MonadExt 
{
  
  
  @:macro public static function runDo<M>(m:ExprRequire<hots.classes.Monad<M>>,
    e1:Expr, e2:Expr = null, e3:Expr = null, e4:Expr = null,
    e5:Expr = null, e6:Expr = null, e7:Expr = null, e8:Expr = null,
    e9:Expr = null, e10:Expr = null, e11:Expr = null
  )
  {
    var maybeNullExprs = [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11];
    var exprs = maybeNullExprs.filter(function (x) return !Check.isConstNull(x));
    var last = exprs[exprs.length -1];
    var head = exprs.removeLast();
    
    var pureExpr = Select.selectEReturn(last).map(function (x) return Make.field(m, "pure").call([x])).getOrElseConst(last);
    
    var res = head.foldRightWithIndex(
      function (x, acc, index) {
        var tup = Select.selectEBinopExprsWithOpFilter(x, function (op) return op == OpLte)
        .map(function (t) return Tup2.create(Select.selectEConstCIdentValue(t._1).getOrError("Left side of <= must be an ident"), t._2))
        .getOrElse(function () return Tup2.create("_", x));
        
        var f = Make.funcExpr([Make.funcArg(tup._1, false)], Make.returnExpr(acc));
        var flatMapCall = Make.field(m, "flatMap").call([tup._2, f]);
        
        return flatMapCall;
        
      }, pureExpr);

    return res;
  }
  
  
  #if !macro
  /*
  public static function lift2 <M, A1, A2, R>(m:Monad<M>, f:A1->A2->R ):Of<M, A1>->Of<M, A2>->Of<M, R>
  {
    return function (v1:Of<M, A1>, v2:Of<M, A2>) {
      return m.flatMap(v1, function (x1) {
        return m.flatMap(v2, function (x2) {
          return m.pure(f(x1,x2));
        });
      });
    };
  }
  
  public static function ap<M,A,B>(m:Monad<M>, f:Of<M, A->B>):Of<M, A>->Of<M,B> 
  {
    return function (v:Of<M,A>) {
      return m.flatMap(f, function (f1:A->B):Of<M,B> {
        return m.map(function (a2:A):B {
          return f1(a2);
        }, v);
      });
    };
    
  }
  public static function sequence <M,B>(monad:Monad<M>, arr:Array<Of<M, B>>):Of<M,Array<B>>
  {
    var arrMonad = ArrayOfMonad.get();
    var k = function (m1:Of<M,B>,m2:Of<M,Array<B>>) {
      return monad.flatMap(m1, function (x:B) {
        return monad.flatMap(m2, function (xs:Array<B>) {
          return monad.pure([x].concat(xs));
        });
      });
      
    }
    return ArrayExt.foldRight(arr, k, monad.pure([]));
  }
  
  public static inline function mapM <M,A,B>(mon:Monad<M>, f:A->Of<M,B>, a:Array<A>):Of<M,Array<B>>
  {
    return sequence(mon, ArrayExt.map(a,f));
  }
  */
  #end
  // from functor
  
  
  
  
  
}