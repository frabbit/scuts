package hots.extensions;


#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import hots.Implicit;
import hots.macros.Implicits;
import scuts.Scuts;

#else

import hots.classes.MonadZero;
import hots.instances.ArrayOfMonad;

import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Monad;

typedef MonadExtApplicativeExt = hots.extensions.Applicatives;
#end


class Monads 
{
  @:macro public static function runDo<M>(exprs:Array<Expr>)
  {
    
    
    var e  = exprs == null ? [] : exprs;
    
    return hots.macros.syntax.DoGenForMonads.runDo1(m, e);
    
  }
  
  #if !macro

  public static inline function flatMap <M,A,B> (of:Of<M, A>, f:A->Of<M, B>, m:Implicit<Monad<M>>):Of<M,B> return m.flatMap(of, f)
  
  public static inline function map <M,A,B> (of:Of<M, A>, f:A->B, m:Implicit<Monad<M>>):Of<M,B> return m.map(of, f)
  
  public static function lift2 <M, A1, A2, R>(m:Monad<M>, f:A1->A2->R ):Of<M, A1>->Of<M, A2>->Of<M, R>
  {
    return function (v1:Of<M, A1>, v2:Of<M, A2>) {
      return m.flatMap(v1, function (x1) 
        return m.flatMap(v2, function (x2) 
          return m.pure(f(x1,x2))
        )
      );
    }
  }
  
  public static function ap<M,A,B>(m:Monad<M>, f:Of<M, A->B>):Of<M, A>->Of<M,B> 
  {
    return function (v:Of<M,A>) {
      return m.flatMap(f, function (f1:A->B) 
        return m.map(v,function (a2:A) return f1(a2))
      );
    }
  }
  
  public static function sequence <M,B>(monad:Monad<M>, arr:Array<Of<M, B>>):Of<M,Array<B>>
  {
    
    var k = function (m1:Of<M,B>,m2:Of<M,Array<B>>) {
      return monad.flatMap(m1, function (x:B) 
         return monad.flatMap(m2, function (xs:Array<B>) 
          return monad.pure([x].concat(xs))
          )
      );
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
}

#if !macro

class WithMonad<M,A> 
{
  
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

class WithMonadZeros 
{
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



private class WithMonadZero<M,A> 
{
  public var of(default, null) : Of<M, A>;
  public var monad(default, null) : MonadZero<M>;
  public var filter : A->Bool;
  
  public function new (of:Of<M,A>, m:MonadZero<M>, ?filter:A->Bool) 
  {
    this.of = of;
    this.monad = m;
    this.filter = filter == null ? function (_) return true : filter;
  }
}

#end
