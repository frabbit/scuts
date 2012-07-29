package hots.extensions;
#if !macro

import hots.classes.MonadZero;
import hots.instances.ArrayOfMonad;

import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Monad;

typedef MonadExtApplicativeExt = hots.extensions.Applicatives;

#end

#if (macro || display)
import hots.macros.utils.Utils;
import scuts.mcore.Cast;
import scuts.mcore.MContext;
import scuts.mcore.MType;
import haxe.macro.Context;
import scuts.core.types.Tup2;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.mcore.Check;
import haxe.macro.Expr;
import scuts.mcore.Select;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.Arrays;
using scuts.core.extensions.Options;
import scuts.macros.Do;
using scuts.macros.Do;
import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.Print;
import scuts.mcore.Check;
import haxe.macro.Expr;
import scuts.mcore.Select;
import scuts.Scuts;
using scuts.mcore.Check;
#end




class Monads 
{
  
  #if (macro || display)
  public static function runDo1 <M>(monad:ExprRequire<hots.classes.Monad<M>>, exprs:Array<Expr>) {
    
    var last = exprs[exprs.length -1];
    var head = exprs.removeLast();
    
    // monad zero supports filtering, allows filter expressions in do syntax
    var isMonadZero = 
      MContext.typeof(monad)
      .map(function (x) {
        var testForZero = "{ var m : " + Print.type(x) + " = null; var mz : hots.classes.MonadZero<Dynamic> = m; mz;}";
        
        return MContext.isTypeable(Context.parse(testForZero, Context.currentPos()));
      }).getOrElseConst(false);
    
    
    
    var op = Do.exprsToDoOp(exprs);
    
    var res = if (monad.isConst()) {
      doOpToExpr(op, monad, isMonadZero);
    } else {
      // evaluate monad expr only once
      Make.block([Make.varExpr("___monad", monad), doOpToExpr(op, Make.constIdent("___monad"), isMonadZero)]);
    }
    
    trace(Print.expr(res));
    
    return res;
    
  }
  
  static public function doOpToExpr(op:DoOp, monad:Expr, isMonadZero:Bool) 
  {
    return switch (op) {
      case OpFilter(e, op): Scuts.unexpected();       
      case OpFlatMapOrMap(ident, val, op):  
        op.getFilter().map(function (x) {
          if (!isMonadZero) Scuts.error("Using filter in Do Expressions for Monads is only possible if monad is actually a MonadZero");
          var nextFilter = x._2.getFilter();
          
          return 
            nextFilter.map(function (y) 
            {
              var newOp = OpFlatMapOrMap(ident, val, OpFilter(x._1.inParenthesis().binopBoolOr(y._1.inParenthesis()), y._2));
              return doOpToExpr(newOp, monad, isMonadZero);
            }).getOrElse(function () return 
            {
              
              var thenExpr = x._1;
              // create guard expression
              var ifExpr = Make.ifExpr(x._1, doOpToExpr(x._2, monad, isMonadZero), monad.field("zero").call([])).asReturn();
              
              var newOp = OpFlatMapOrMap(ident, val, OpExpr(ifExpr));
              return doOpToExpr(newOp, monad, isMonadZero);
            });
        })
        .getOrElse(function () {
          
          return op.getLastReturnExpr().map(function (x)
            return monad.field("map").call([val, Make.funcExpr([Make.funcArg(ident, false)], x.asReturn())])
          ).getOrElse(function ()
            return monad.field("flatMap").call([val,Make.funcExpr([Make.funcArg(ident, false)], Make.returnExpr(doOpToExpr(op, monad, isMonadZero)))])
          );
        });
      case OpReturn(e, optionOp): 
        optionOp.map(function (op) return doOpToExpr(OpFlatMapOrMap("_", monad.field("pure").call([e]), op), monad, isMonadZero))
        .getOrElse(function () return monad.field("pure").call([e]));
      case OpLast(op): doOpToExpr(op, monad, isMonadZero);
      case OpExpr(e): e;
    }
  }
  
  #end
  
  @:macro public static function runDo<M>(m:ExprRequire<hots.classes.Monad<M>>,
    e1:Expr, e2:Expr = null, e3:Expr = null, e4:Expr = null,
    e5:Expr = null, e6:Expr = null, e7:Expr = null, e8:Expr = null,
    e9:Expr = null, e10:Expr = null, e11:Expr = null, e12:Expr = null, e13:Expr = null
  )
  {
    var maybeNullExprs = [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11,e12,e13];
    var exprs = maybeNullExprs.filter(function (x) return !Check.isConstNull(x));
    
    return runDo1(m, exprs);
    
  }
  
  
  #if !macro
  
  public static inline function flatMap <M,A,B> (of:Of<M, A>, f:A->Of<M, B>, m:Monad<M>):Of<M,B> return m.flatMap(of, f)
  
  public static inline function map <M,A,B> (of:Of<M, A>, f:A->B, m:Monad<M>):Of<M,B> return m.map(of, f)
  
  
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
        return m.map(v,function (a2:A):B {
          return f1(a2);
        });
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
    return Arrays.foldRight(arr, k, monad.pure([]));
  }
  
  public static inline function mapM <M,A,B>(mon:Monad<M>, f:A->Of<M,B>, a:Array<A>):Of<M,Array<B>>
  {
    return sequence(mon, Arrays.map(a,f));
  }
  
  public static function with <M,A> (mon:Monad<M>, of:Of<M,A>) return new WithMonad(of, mon)
  
  public static function zeroWith <M,A> (mon:MonadZero<M>, of:Of<M,A>) return new WithMonadZero(of, mon)
  #end
  // from functor
}

#if !macro



class WithMonad<M,A> {
  public var of(default, null) : Of<M, A>;
  public var monad(default, null) : Monad<M>;
  
  public function new (of:Of<M,A>, m:Monad<M>) {
    this.of = of;
    this.monad = m;
  }
  
  public function flatMap <B>(f:A->Of<M,B>):WithMonad<M,B>
  {
    return new WithMonad(monad.flatMap(of, f), monad);
  }
  
  public function map <B>(f:A->B):WithMonad<M,B>
  {
    return new WithMonad(monad.map(of, f), monad);
  }
}
using scuts.core.extensions.Predicates;

class WithMonadZeroExt {
  
  static function mkFlatMap <M,A,B>(mz:WithMonadZero<M,A>, mkOf:A->Of<M,B>):WithMonadZero<M,B>
  {
    var f1 = function (a) return if (mz.filter(a)) mkOf(a) else mz.monad.zero();
    return new WithMonadZero(mz.monad.flatMap(mz.of, f1), mz.monad);
  }
  
  public static function flatMap <M,A,B>(mz:WithMonadZero<M,A>, f:A->WithMonadZero<M,B>):WithMonadZero<M,B>
  {
    return mkFlatMap(mz, function (a) return f(a).of);
  }
  
  public static function map <M,A,B>(mz:WithMonadZero<M,A>, f:A->B):WithMonadZero<M,B>
  {
    return mkFlatMap(mz, function (a) return mz.monad.pure(f(a)));
  }
  
  public static function withFilter <M,A>(mz:WithMonadZero<M,A>, f:A->Bool):WithMonadZero<M,A>
  {
    return new WithMonadZero(mz.of, mz.monad, mz.filter.and(f));
  }
}

private class WithMonadZero<M,A> {
  public var of(default, null) : Of<M, A>;
  public var monad(default, null) : MonadZero<M>;
  public var filter : A->Bool;
  
  public function new (of:Of<M,A>, m:MonadZero<M>, ?filter:A->Bool) {
    this.of = of;
    this.monad = m;
    this.filter = filter == null ? function (_) return true : filter;
  }
}

#end