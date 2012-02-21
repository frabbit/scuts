package scuts.core.extensions;

import scuts.core.types.Future;

import scuts.core.types.Tup2;
import scuts.core.types.Tup3;
import scuts.core.types.Tup4;

using scuts.core.extensions.ArrayExt;

//using scuts.core.lifting.FutureLifting;
using scuts.core.extensions.FunctionExt;
/**
 * ...
 * @author 
 */
/*
private typedef Fut<A> =        Future<A>;
private typedef Fut2<A,B> =     Tup2< Fut<A>, Fut<B> >;
private typedef Fut3<A,B,C> =   Tup3< Fut<A>, Fut<B>, Fut<C> >;
private typedef Fut4<A,B,C,D> = Tup4< Fut<A>, Fut<B>, Fut<C>, Fut<D> >;
*/
 
class FutureExt {
  
  public static function flatMap < S,T > (w:Future<S>, f:S->Future<T>):Future<T>
  {
    var res = new Future();
    w.deliverTo(function (r) 
    {
      var f1 = f(r);
      f1.deliverTo(function (r) res.deliver(r));
      f1.ifCanceled(function () res.cancel());
    });
    w.ifCanceled(function () 
    {
      res.cancel();
    });
    
    return res;
  }
  
  
  public static function flatten <T>(a:Future<Future<T>>):Future<T>
  {
    var f = new Future();
    a.deliverTo(function (v) {
      v.deliverTo(function (v2) f.deliver(v2));
      v.ifCanceled(function () f.cancel());
    });
    a.ifCanceled(function () f.cancel());
    return f;
  }
  
  public static inline function map < S, T > (w:Future<S>, f:S->T):Future<T>
  {
    var f1 = function (f:Future<S>) {
      
      var fut = new Future();
      
      fut.deliverTo(function (v) fut.deliver(v))
         .ifCanceled(function () fut.cancel());
      
      return fut;
    }
    
    return f1(w);
  }
  /*
  public static inline function map2 < S1, S2, T> (a:Future<S1>, f:S1->S2->T, b:Future<S2>):Future<T>
  {
    return f.liftWithFuture()(a, b);
  }
  
  public static inline function map3 < S1, S2, S3, T> (a:Future<S1>, f:S1->S2->S3->T, b:Future<S2>, c:Future<S3>):Future<T>
  {
    return f.liftWithFuture()(a, b, c);
  }
  
  public static inline function map4 < S1, S2, S3, S4, T> (a:Future<S1>, f:S1->S2->S3->S4->T, b:Future<S2>, c:Future<S3>, d:Future<S4>):Future<T>
  {
    return f.liftWithFuture()(a, b, c, d);
  }
  */
}
/*
class Futures1 {
  public static function and <A,B>(a:Fut<A>, b:Fut<B>):Fut2<A,B>
  {
    return Tup2.create(a,b);
  }
}
class Futures2 {
  
  
  public static function and <A,B,C>(a:Fut2<A,B>, b:Fut<C>):Fut3<A,B,C>
  {
    return Tup3.create(a._1, a._2, b);
  }
  
  public static function map <A,B, C>(t:Fut2<A,B>, f:A->B->C):Fut<C>
  {
    return Future.lift(f)(t._1, t._2);
  }
  
 
}

class Futures3 {
  public static function and <A,B,C,D>(a:Fut3<A,B,C>, b:Fut<D>):Fut4<A,B,C,D>
  {
    return Tup4.create(a._1, a._2, a._3, b);
  }
  
  public static function map <A,B, C,D>(t:Fut3<A,B,C>, f:A->B->C->D):Fut<D>
  {
    return Future.lift(f)(t._1, t._2, t._3);
  }
  
  
  
}
*/