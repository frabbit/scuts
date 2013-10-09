package scuts.core;
import scuts.core.debug.Assert;

import scuts.core.Tuples;

using scuts.core.Validations;
import scuts.core.Unit;
import scuts.Scuts;


using scuts.core.Options;
using scuts.core.Promises;
using scuts.core.Predicates;

using scuts.core.Functions;
using scuts.core.Promises;


#if scuts_multithreaded
typedef Mutex = 
  #if cpp
  cpp.vm.Mutex 
  #elseif neko 
  neko.vm.Mutex 
  #else 
  #error "not implemented" 
  #end

#end

private typedef Percent = Float;

typedef Throwable = Dynamic;

typedef PromiseD<T> = Promise<Throwable, T>;

typedef PromiseU<T> = Promise<Unit, T>;


@:allow(scuts.core.Promises)
class Promise<Err, T> 
{
  
  #if scuts_multithreaded
  var _mutex:Mutex;
  #end
  
  var _completeListeners:Array<Validation<Err, T>->Void>;
  var _failureListeners:Array<Err->Void>;
  var _successListeners:Array<T->Void>;

  var _progressListeners:Array<Percent->Void>;
  
  var _value:Option<Validation<Err, T>>;
  var _complete:Bool;
  
  function new () 
  {
    initMutex();
    
    _complete = false;
    _value = None;
    
    clearListeners();
  }

}

/**
 * Represents a deferred value, that must be completed. 
 * It can only be created with Promises.deferred().
 *
 */
abstract Deferred<A,B>(Promise<A,B>) to Promise<A,B> {
  @:allow(scuts.core.Promises)
  inline function new (p:Promise<A,B>) this = p;

  public inline function promise ():Promise<A,B> {
    return this;
  }
}




@:allow(scuts.core.Promise)
class Promises
{
  
  inline static function clearListeners <T,E>(p:Promise<E,T>)
  {
    p._completeListeners = [];
    p._failureListeners = [];
    p._progressListeners = [];
    p._successListeners = [];
  }

  inline static function lock <T,E>(p:Promise<E,T>) 
  {
    #if scuts_multithreaded
    p._mutex.acquire(); 
    #end
  }
  
  inline static function unlock <T,E>(p:Promise<E,T>) 
  {
    #if scuts_multithreaded 
    p._mutex.release(); 
    #end
  }
  
  inline static function initMutex <T,E>(p:Promise<E,T>) 
  {
    #if scuts_multithreaded
    p._mutex = new Mutex();
    #end
    
  }
  
  inline static function isCompleteDoubleCheck<T,E>(p:Promise<E,T>) 
  {
    #if scuts_multithreaded
    return p.isComplete();
    #else
    return false;
    #end
  }
  



  public static function extract <E, T>(p:Promise<E, T>):Validation<E, T> 
  {
    return p._value.getOrError("error result is not available");
  }

  public inline static function isComplete <E,T>(p:Promise<E,T>) return p._complete;

  public inline static function isSuccess <E,T>(p:Promise<E,T>) return p._value.isSome() && p._value.extract().isSuccess();
  
  public inline static function isFailure <E,T>(p:Promise<E,T>) return p._value.isSome() && p._value.extract().isFailure();
  
  public static function valueOption <E,T>(p:Promise<E,T>):Option<Validation<E, T>> return p._value;

  public static function onProgress <E,T>(p:Promise<E,T>,f:Percent->Void):Promise<E,T> 
  {
    if (isComplete(p)) f(1.0)
    else
    {
      lock(p);
      if (!p.isCompleteDoubleCheck()) p._progressListeners.push(f)
      else p.onProgress(f);
      unlock(p);
    } 
    return p;
  }
  


  public static function progress <E,T>(p:Deferred<E,T>,percent:Percent):Deferred<E,T>
  {
    Assert.isTrue(percent >= 0.0 && percent <= 1.0, null);
    for (l in p.promise()._progressListeners) l(percent);
    return asDeferred(p);
  }

  public static function complete <E, T>(p:Deferred<E, T>,val:Validation<E,T>):Deferred<E,T> 
  {
    return if (!p.isComplete()) tryComplete(p, val) else throw "Cannot complete already completed Promise";
  }
 
  public static function tryComplete <E, T>(p:Deferred<E, T>,val:Validation<E,T>):Deferred<E,T> 
  {
    return asDeferred(if (p.isComplete()) p
    else 
    {
      p.lock();
      if (!p.isCompleteDoubleCheck()) 
      {
        switch (val) 
        {
          case Success(s): for (c in p.promise()._successListeners) c(s);
          case Failure(f): for (c in p.promise()._failureListeners) c(f);
        }
        for (c in p.promise()._completeListeners) c(val);
        p.promise()._value = Some(val);
        p.promise()._complete = true;
        p.progress(1.0);
        
        
        p.clearListeners();
      }
      p.unlock();
      p;
    });
  }
  
  static inline function asDeferred <A,B>(p:Promise<A,B>) {
    return new Deferred(p);
  }

  public static function tryFailure <E, T>(p:Deferred<E, T>, f : E):Deferred<E,T>  
  {
    return asDeferred(p.tryComplete(Failure(f)));
  }

  public static function trySuccess <E, T>(p:Deferred<E, T>, t : T):Deferred<E,T> 
  {
    return asDeferred(p.tryComplete(Success(t)));
  }

  public static function failure <E, T>(p:Deferred<E, T>, f : E):Deferred<E,T>  
  {
    return asDeferred(p.complete(Failure(f)));
  }

  public static function success <E, T>(p:Deferred<E, T>, t : T):Deferred<E,T> 
  {
    return asDeferred(p.complete(Success(t)));
  }
  
  public static function onComplete <E, T>(p:Promise<E, T>,f:Validation<E,T>->Void) 
  {
    if (p.isComplete()) 
    {
      f(p.extract());
    } 
    else
    {
      p.lock();
      if (!p.isCompleteDoubleCheck())
        p._completeListeners.push(f);
      else p.onComplete(f);
      p.unlock();
    } 
    
    return p;
  }
  
  public static function onFailureVoid <E, T>(p:Promise<E,T>,f:Void->Void) 
  {
    return onFailure(p, f.promote());
  } 
  

  public static function onFailure <E, T>(p:Promise<E,T>,f:E->Void) 
  {
    if (!p.isComplete()) 
    {
      p.lock();
      if (!p.isCompleteDoubleCheck()) p._failureListeners.push(f);
      else p.onFailure(f);
      p.unlock();
    } 
    else if (p.isFailure()) f(p.extract().extractFailure());
    
    return p;
  }

  public static function onSuccess <E,T>(p:Promise<E,T>,f:T->Void) 
  {
    if (!p.isComplete()) 
    {
      p.lock();
      if (!p.isCompleteDoubleCheck()) p._successListeners.push(f);
      else p.onSuccess(f);
      p.unlock();
      
      
    } else if (p.isSuccess()) f(p.extract().extract());
    return p;
  }

  public static function toString <E,T>(p:Promise<E,T>) {
    return 
      if (isComplete(p))       "Promise(" + p._value.extract() + ")"
      else                     "Unfullfilled Promise";
  }

  public static function asPromiseD <E,T>(p:Promise<E,T>):PromiseD<T> return p;
  public static function asPromiseU <E,T>(p:Promise<E,T>):PromiseU<T> return p.mapFailure(function (_) return Unit);

  @:noUsing public static function zipIterableWith <A,B,E> (a:Iterable<Promise<E,A>>, f:Iterable<A>->B):Promise<E,B>
  {

    var fut = deferred();
    var res = [];
    var progs = [];
    
    
    
    var len = -1;
    
    var count = 0;
    var isDelivered = false;
    function check () 
    {
      if (len > -1 && count == len) {
        if (isDelivered) {
          Scuts.error("Cannot deliver twice");
        }
        isDelivered = true;
        fut.success(f(res));
      }
    }
    function updateProgress () {
      if (len > 0) {
        var r = 0.0;
        for (p in progs) {
          r += p;
        }
        fut.progress(r/len);
      }
       
    }
    var x = 0;

    for (f in a) {
      var index = x;
      progs[index] = 0.0;
      f.onSuccess(function (v) { 
        if (res[index] != null) throw "ERROR";
        res[index] = v; 
        
        count++; 
        check(); 
        } )
      .onFailure(fut.failure)
      .onProgress(function (p) {
        progs[index] = p;
        updateProgress();
      });
      x++;
    }
    len = x;
    updateProgress();
    check();
    return fut;
  }
  
  @:noUsing public static function zipIterable <A,E> (a:Iterable<Promise<E,A>>):Promise<E,Iterable<A>>
  {
    return zipIterableWith(a, Scuts.id);
  }


  
  public static function apply<A,B,E>(f:Promise<E,A->B>, p:Promise<E,A>):Promise<E,B> 
  {
    return zipWith(f, p, function (g, x) return g(x)); 
  }
  
  @:noUsing public static function cancelled <E,S>(e:E):Promise<E,S> {
    var p = deferred();
    p.failure(e);
    return p;
  }
  
  @:noUsing public static function fromValidation <F,S>(v:Validation<F,S>):Promise<F,S> 
  {
    return deferred().complete(v);
  }

  @:noUsing public static function pure <E,S>(s:S):Promise<E,S> 
  {
    return deferred().success(s);
  }
  
  @:noUsing public static function deferred <E,S>():Deferred<E,S> 
  {
    return new Deferred(new Promise());
  }



  public static function flatMapBoth < E,S,T,X,E2 > (p:Promise<E,S>, ff:E->Promise<E2,X>, fs:S->Promise<E2,X>):Promise<E2,X>
  {
    function f1(v:Validation<E,S>) return switch (v) 
    {
      case Success(s): fs(s);
      case Failure(f): ff(f);
    }
    return flatMapValidation(p,f1);
    
  }

  public static function flatMapValidation < E,S,E2,S2 > (p:Promise<E,S>, f:Validation<E,S>->Promise<E2,S2>):Promise<E2,S2>
  {
    var res = deferred();
    
    function next(v) 
    {
      var p1 = f(v);
      p1.onProgress(function (p) res.progress(0.5 + p * 0.5))
        .onComplete(res.complete);
        
    }
    
    p.onProgress(function (p) res.progress(p * 0.5))
     .onComplete(next);
    
    return res; 
  }

  public static function flatMap < E,S,T > (p:Promise<E,S>, f:S->Promise<E,T>):Promise<E,T>
  {
    var res = deferred();
    trace("1");
    function success(r) 
    {
      var p1 = f(r);
      trace("helo");
      p1.onProgress(function (p) res.progress(0.5 + p * 0.5))
        .onSuccess(res.success)
        .onFailure(res.failure);
    }
    
    p.onProgress(function (p) res.progress(p * 0.5))
     .onSuccess(success)
     .onFailure(res.failure);
     
    
    return res;
  }

  public static inline function flatMap2 < E,S1,S2,T > (p:Promise<E,Tup2<S1,S2>>, f:S1->S2->Promise<E,T>):Promise<E,T> 
  {
    return flatMap(p, f.tupled());
  }

  public static inline function flatMap3 < E,S1,S2,S3,T > (p:Promise<E,Tup3<S1,S2,S3>>, f:S1->S2->S3->Promise<E,T>):Promise<E,T> 
  {
    return flatMap(p, f.tupled());
  }

  public static inline function flatMap4 < E,S1,S2,S3,S4,T > (p:Promise<E,Tup4<S1,S2,S3,S4>>, f:S1->S2->S3->S4->Promise<E,T>):Promise<E,T> 
  {
    return flatMap(p, f.tupled());
  }
  
  public static inline function flatMap5 < E,S1,S2,S3,S4,S5,T > (p:Promise<E,Tup5<S1,S2,S3,S4,S5>>, f:S1->S2->S3->S4->S5->Promise<E,T>):Promise<E,T> 
  {
    return flatMap(p, f.tupled());
  }

  

  public static function map < S, T,E > (p:Promise<E,S>, f:S->T):Promise<E,T>
  {
    var res = deferred();
  
    p.onSuccess (f.next(res.success))
     .onFailure(res.failure)
     .onProgress (res.progress);
      
    return res;
  }

  public static inline function map2 < E,S1,S2,T > (p:Promise<E,Tup2<S1,S2>>, f:S1->S2->T):Promise<E,T> {
    return map(p, f.tupled());
  }

  public static inline function map3 < E,S1,S2,S3,T > (p:Promise<E,Tup3<S1,S2,S3>>, f:S1->S2->S3->T):Promise<E,T> {
    return map(p, f.tupled());
  }

  public static inline function map4 < E,S1,S2,S3,S4,T > (p:Promise<E,Tup4<S1,S2,S3,S4>>, f:S1->S2->S3->S4->T):Promise<E,T> {
    return map(p, f.tupled());
  }

  public static inline function map5 < E,S1,S2,S3,S4,S5,T > (p:Promise<E,Tup5<S1,S2,S3,S4,S5>>, f:S1->S2->S3->S4->S5->T):Promise<E,T> {
    return map(p, f.tupled());
  }

  public static function recover < T,E, EE > (p:Promise<E,T>, convert:E->T):Promise<E,T>
  {
    return p.flatMapValidation(function (v) return switch (v) 
    {
      case Success(_): p;
      case Failure(f): Promises.pure(convert(f));
    });
  }

  public static function recoverWith < T,E,E2> (p:Promise<E,T>, convert:E->Promise<E,T>):Promise<E,T>
  {
    return p.flatMapValidation(function (v) return switch (v) 
    {
      case Success(_): p;
      case Failure(f): convert(f);
    });
  }

  public static function mapFailure < T,E, EE > (p:Promise<E,T>, f:E->EE):Promise<EE,T>
  {
    var res = deferred();
 
    p.onSuccess (res.success)
     .onFailure(f.next(res.failure))
     .onProgress (res.progress);
      
    return res;
  }
  
  public static function filter <E,T>(p:Promise<E,T>, f:T->Bool, failureVal:E):Promise<E, T>
  {
    var res = deferred();
    p.onSuccess (function (x) if (f(x)) res.success(x) else res.failure(failureVal))
     .onFailure(res.failure)
     .onProgress (res.progress);
    return res;
  }
  
  public static inline function filterUnit <T>(p:PromiseD<T>, f:T->Bool):PromiseD<T>
  {
    return filter(p, f, Unit);
  }
  
  public static function flatten <E,T>(p:Promise<E,Promise<E,T>>):Promise<E, T>
  {
    var res = deferred();
    
    function complete (x:Promise<E, T>) {
      x.onComplete (res.complete)
       .onProgress (res.progress);
    }
    
    p.onSuccess(complete)
     .onFailure( res.failure)
     .onProgress (res.progress);
    return res;
  }

  public static function switchWith<A,B,Z> (a:Promise<Z,A>, b:Void->Promise<Z,B>):Promise<Z,B>
  {
    return a.flatMap(function (_) return b());
  }

  public static inline function switchC<A,C,Z> (a:Promise<Z,A>, c:C):Promise<Z,C>
  {
    return a.switchWith(function () return Promises.pure(c));
  }

  public static inline function switchP<A,B,Z> (a:Promise<Z,A>, b:Promise<Z,B>):Promise<Z,B>
  {
    return a.switchWith(function () return b);
  }
  
  public static inline function zip<A,B,Z>(a:Promise<Z,A>, b:Promise<Z,B>):Promise<Z,Tup2<A,B>>
  {
    return liftF2(Tup2.create)(a,b);
  }
  
  public static inline function 
  zip3<A,B,C,Z>(a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>):Promise<Z,Tup3<A,B,C>>
  {
    return liftF3(Tup3.create)(a,b,c);
  }
  
  public static inline function 
  zip4<A,B,C,D,Z>(a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, d:Promise<Z,D>):Promise<Z,Tup4<A,B,C,D>>
  {
    return liftF4(Tup4.create)(a,b,c,d);
  }
  
  public static inline function 
  zipWith<A,B,C,Z>(a:Promise<Z,A>, b:Promise<Z,B>, f:A->B->C):Promise<Z,C>
  {
    return liftF2(f)(a,b);
  }
  
  public static inline function 
  zipWith3<A,B,C,D,Z>(a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, f:A->B->C->D):Promise<Z,D>
  {
    return liftF3(f)(a,b,c);
  }
  
  public static inline function 
  zipWith4<A,B,C,D,E,Z>(a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, d:Promise<Z,D>, f:A->B->C->D->E):Promise<Z,E>
  {
    return liftF4(f)(a,b,c,d);
  }
  
  @:noUsing public static function liftF0 <E,A> (f:Void->A):Void->Promise<E,A> 
  {
    return function () return deferred().success(f());
  }

  @:noUsing public static function liftF1 <E,A, B> (f:A->B):Promise<E,A>->Promise<E,B> 
  {
    return function (a:Promise<E,A>) {
      var res = deferred();
      a.onSuccess(f.next(res.success))
       .onFailure(res.failure)
       .onProgress(res.progress);
      return res;
    }
  }

  @:noUsing public static function liftF2 <A, B, C, E> (f:A->B->C):Promise<E,A>->Promise<E,B>->Promise<E,C> 
  {
    return function (a:Promise<E,A>, b:Promise<E,B>) {
      var res = deferred();
      
      var valA = None;
      var valB = None;
      
      function check () if (valA.isSome() && valB.isSome()) 
      {
        res.success(f(valA.extract(), valB.extract()));
      }
      
      function progress (p:Float) res.progress(p * 0.5);
      
      a.onSuccess(function (r) { valA = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);
      b.onSuccess(function (r) { valB = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);

      return res;
    }
  }

  @:noUsing public static function 
  liftF3 <A, B, C, D,Z> (f:A->B->C->D):Promise<Z,A>->Promise<Z,B>->Promise<Z,C>->Promise<Z,D>
  {
    return function (a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>) {
      var res = deferred();
      
      var valA = None;
      var valB = None;
      var valC = None;
      
      function check () if (valA.isSome() && valB.isSome() && valC.isSome()) {
        res.success(f(valA.extract(), valB.extract(), valC.extract()));
      }

      function progress (p:Float) res.progress(p * (1 / 3));
      
      a.onSuccess(function (r) { valA = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);
      b.onSuccess(function (r) { valB = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);
      c.onSuccess(function (r) { valC = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);
      
      return res;
    }
  }

  @:noUsing public static function 
  liftF4 <A, B, C, D, E,Z> (f:A->B->C->D->E):Promise<Z,A>->Promise<Z,B>->Promise<Z,C>->Promise<Z,D>->Promise<Z,E>
  {
    return function (a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, d:Promise<Z,D>) {
      var res = deferred();
      
      var valA = None;
      var valB = None;
      var valC = None;
      var valD = None;
      
      function check () if (valA.isSome() && valB.isSome() && valC.isSome() && valD.isSome()) {
        res.success(f(valA.extract(), valB.extract(), valC.extract(), valD.extract()));
      }

      function progress (p:Float) res.progress(p * 0.25);
      
      a.onSuccess(function (r) { valA = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);
      b.onSuccess(function (r) { valB = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);
      c.onSuccess(function (r) { valC = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);
      d.onSuccess(function (r) { valD = Some(r); check(); }).onFailure(res.tryFailure).onProgress(progress);

      return res;
    }
  }
  
  @:noUsing public static function 
  liftF5 <A, B, C, D, E, F,Z> (f:A->B->C->D->E->F)
  :Promise<Z,A>->Promise<Z,B>->Promise<Z,C>->Promise<Z,D>->Promise<Z,E>->Promise<Z,F>
  {
    return function (a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, d:Promise<Z,D>, e:Promise<Z,E>) {
      var res = deferred();
      
      var valA = None;
      var valB = None;
      var valC = None;
      var valD = None;
      var valE = None;
      
      function check () if (valA.isSome() && valB.isSome() && valC.isSome() && valD.isSome() && valE.isSome()) {
        res.success(f(valA.extract(), valB.extract(), valC.extract(), valD.extract(), valE.extract()));
      }

      function progress (p:Float) res.progress(p * 0.2);
      
      a.onSuccess(function (r) { valA = Some(r); check(); } ).onFailure(res.tryFailure).onProgress(progress);
      b.onSuccess(function (r) { valB = Some(r); check(); } ).onFailure(res.tryFailure).onProgress(progress);
      c.onSuccess(function (r) { valC = Some(r); check(); } ).onFailure(res.tryFailure).onProgress(progress);
      d.onSuccess(function (r) { valD = Some(r); check(); } ).onFailure(res.tryFailure).onProgress(progress);
      e.onSuccess(function (r) { valE = Some(r); check(); } ).onFailure(res.tryFailure).onProgress(progress);
      
      return res;
    }
  }

  

}



