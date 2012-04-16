package scuts.core.extensions;

import scuts.core.types.Future;

import scuts.core.types.Tup2;
import scuts.core.types.Tup3;
import scuts.core.types.Tup4;

import scuts.core.types.Option;
using scuts.core.extensions.Options;

using scuts.core.extensions.Arrays;

using scuts.core.extensions.Functions;

using scuts.core.extensions.Futures;
using scuts.core.extensions.Predicates;
using scuts.core.extensions.Functions;

class Futures {
  
  
  
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
  
  public static function filter <T>(a:Future<T>, f:T->Bool):Future<T>
  {
    
    var res = new Future();
    a.deliverTo(function (v2) if (f(v2)) res.deliver(v2) else res.cancel());
    a.ifCanceled(function () res.cancel());
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
  
  public static function map < S, T > (future:Future<S>, f:S->T):Future<T>
  {
    var res = new Future();
    future
      .deliverTo(function (x) res.deliver(f(x)))
      .ifCanceled(function () res.cancel());
    
    
    return res;
  }
  
  public static function flatMapWithFilter < S,T > (fut:Future<S>, f:S->Future<T>, filter:S->Bool):Future<T>
  {
    var res = new Future();
    
    fut
    .deliverTo(function (s) {
      if (filter(s)) 
      {
        var f1 = f(s);
        f1
        .deliverTo(function (x) res.deliver(x))
        .ifCanceled(function () res.cancel());
      } 
      else res.cancel();
    })
    .ifCanceled(function () res.cancel());
    
    return res;
  }
  
  public static function mapWithFilter < S, T > (future:Future<S>, f:S->T, filter:S->Bool):Future<T>
  {
    var res = new Future();
    future
      .deliverTo(function (x) if (filter(x)) res.deliver(f(x)) else res.cancel())
      .ifCanceled(function () res.cancel());

    return res;
  }
  
  public static function withFilter < T > (future:Future<T>, filter:T->Bool):WithFilter<T>
  {
    return new WithFilter(future, filter);
  }
  
  public static function then<A,B> (a:Future<A>, b:Future<B>):Future<B>
  {
    return a.flatMap(function (_) return b);
  }
  
  public static function zip<A,B>(a:Future<A>, b:Future<B>):Future<Tup2<A,B>>
  {
    return Tup2.create.liftFutureF2()(a,b);
  }
  
  public static function zip2<A,B,C>(a:Future<A>, b:Future<B>, c:Future<C>):Future<Tup3<A,B,C>>
  {
    return Tup3.create.liftFutureF3()(a,b,c);
  }
  
  public static function zip3<A,B,C,D>(a:Future<A>, b:Future<B>, c:Future<C>, d:Future<D>):Future<Tup4<A,B,C,D>>
  {
    return Tup4.create.liftFutureF4()(a,b,c,d);
  }
  
  public static function zipWith<A,B,C>(a:Future<A>, b:Future<B>, f:A->B->C):Future<C>
  {
    return f.liftFutureF2()(a,b);
  }
  
  public static function zipWith2<A,B,C,D>(a:Future<A>, b:Future<B>, c:Future<C>, f:A->B->C->D):Future<D>
  {
    return f.liftFutureF3()(a,b,c);
  }
  
  public static function zipWith3<A,B,C,D,E>(a:Future<A>, b:Future<B>, c:Future<C>, d:Future<D>, f:A->B->C->D->E):Future<E>
  {
    return f.liftFutureF4()(a,b,c,d);
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



private class WithFilter<A> 
{
  private var filter:A -> Bool;
  private var fut:Future<A>;
  
  public function new (fut:Future<A>, filter:A->Bool) {
    this.fut = fut;
    this.filter = filter;
  }
  
  public function flatMap <B>(f:A->Future<B>):Future<B> return fut.flatMapWithFilter(f, filter)
  public function map <B>(f:A->B):Future<B> return fut.mapWithFilter(f, filter)
  public function withFilter (f:A->Bool):WithFilter<A> return fut.withFilter(filter.and(f))
}

class FutureConversions {
  /**
   * Converts v into a Future and deliver it immediately.
   */
  public static inline function toFuture<T>(val:T):Future<T> 
  {
    return new Future().deliver(val);
  }
  
  public static inline function toArrayFuture<T>(t:T):Array<Future<T>> 
  {
    return [toFuture(t)];
  }
}

class LiftFuture0
{

  public static function liftFutureF0 <A> (f:Void->A):Void->Future<A> 
  {
    return function () {
      var fut = new Future();
      fut.deliver(f());
      return fut;
    }
  }
}

class LiftFuture1 
{
  public static function liftFutureF1 <A, B> (f:A->B):Future<A>->Future<B> 
  {
    return function (a:Future<A>) {
      var fut = new Future();
      a.deliverTo( function (r) fut.deliver(f(r)) );
      a.ifCanceled(function () fut.cancel());
      
      return fut;
    }
  }
}
class LiftFuture2 
{

  public static function liftFutureF2 <A, B, C> (f:A->B->C):Future<A>->Future<B>->Future<C> 
  {
    return function (a:Future<A>, b:Future<B>) {
      var fut = new Future();
      
      var valA = None;
      var valB = None;
      
      function check () {
        if (valA.isSome() && valB.isSome()) {
          fut.deliver(f(valA.value(), valB.value()));
        }
      }
      
      a.deliverTo(function (r) {
        valA = Some(r);
        check();
      });
      
      b.deliverTo(function (r) {
        valB = Some(r);
        check();
      });
      
      var cancel = function () fut.cancel;
      
      a.ifCanceled(cancel);
      b.ifCanceled(cancel);

      return fut;
      
    }
  }

}
class LiftFuture3
{
  public static function liftFutureF3 <A, B, C, D> (f:A->B->C->D):Future<A>->Future<B>->Future<C>->Future<D>
  {
    return function (a:Future<A>, b:Future<B>, c:Future<C>) {
      var fut = new Future();
      
      var valA = None;
      var valB = None;
      var valC = None;
      
      function check () {
        if (valA.isSome() && valB.isSome() && valC.isSome()) {
          fut.deliver(f(valA.value(), valB.value(), valC.value()));
        }
      }
      
      a.deliverTo(function (r) {
        valA = Some(r);
        check();
      });
      b.deliverTo(function (r) {
        valB = Some(r);
        check();
      });
      c.deliverTo(function (r) {
        valC = Some(r);
        check();
      });
      
      
      
      var cancel = function () fut.cancel;
      
      a.ifCanceled(cancel);
      b.ifCanceled(cancel);
      c.ifCanceled(cancel);
      
      return fut;
    }
  }
}

class LiftFuture4 
{  
  public static function liftFutureF4 <A, B, C, D, E> (f:A->B->C->D->E):Future<A>->Future<B>->Future<C>->Future<D>->Future<E>
  {
    return function (a:Future<A>, b:Future<B>, c:Future<C>, d:Future<D>) {
      var fut = new Future();
      
      var valA = None;
      var valB = None;
      var valC = None;
      var valD = None;
      
      function check () {
        if (valA.isSome() && valB.isSome() && valC.isSome() && valD.isSome()) {
          fut.deliver(f(valA.value(), valB.value(), valC.value(), valD.value()));
        }
      }
      
      a.deliverTo(function (r) {
        valA = Some(r);
        check();
      });
      b.deliverTo(function (r) {
        valB = Some(r);
        check();
      });
      c.deliverTo(function (r) {
        valC = Some(r);
        check();
      });
      d.deliverTo(function (r) {
        valD = Some(r);
        check();
      });
      
      var cancel = function () fut.cancel;
      
      a.ifCanceled(cancel);
      b.ifCanceled(cancel);
      c.ifCanceled(cancel);
      d.ifCanceled(cancel);
      
      return fut;
    }
  }
  
}

class LiftFuture5 
{  
  public static function liftFutureF5 <A, B, C, D, E, F> (f:A->B->C->D->E->F):Future<A>->Future<B>->Future<C>->Future<D>->Future<E>->Future<F>
  {
    return function (a:Future<A>, b:Future<B>, c:Future<C>, d:Future<D>, e:Future<E>) {
      var fut = new Future();
      
      var valA = None;
      var valB = None;
      var valC = None;
      var valD = None;
      var valE = None;
      
      function check () {
        if (valA.isSome() && valB.isSome() && valC.isSome() && valD.isSome() && valE.isSome()) {
          fut.deliver(f(valA.value(), valB.value(), valC.value(), valD.value(), valE.value()));
        }
      }
      
      a.deliverTo(function (r) {
        valA = Some(r);
        check();
      });
      b.deliverTo(function (r) {
        valB = Some(r);
        check();
      });
      c.deliverTo(function (r) {
        valC = Some(r);
        check();
      });
      d.deliverTo(function (r) {
        valD = Some(r);
        check();
      });
      e.deliverTo(function (r) {
        valE = Some(r);
        check();
      });
      
      var cancel = function () fut.cancel;
      
      a.ifCanceled(cancel);
      b.ifCanceled(cancel);
      c.ifCanceled(cancel);
      d.ifCanceled(cancel);
      e.ifCanceled(cancel);
      
      return fut;
    }
  }
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