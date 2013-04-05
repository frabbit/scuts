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

//typedef Promise<T> = Promiseeneral<Throwable, T>;

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
  
  public function new () 
  {
    Promises.initMutex(this);
    
    _complete = false;
    _value = None;
    
    clearListeners();
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
  
  public static function progress <E,T>(p:Promise<E,T>,percent:Percent):Promise<E,T>
  {
    Assert.isTrue(percent >= 0.0 && percent <= 1.0, null);
    for (l in p._progressListeners) l(percent);
    return p;
  }

  public static function complete <E, T>(p:Promise<E, T>,val:Validation<E,T>):Promise<E,T> 
  {
    return if (!p.isComplete()) tryComplete(p, val) else throw "Cannot complete already completed Promise";
  }
 
  public static function tryComplete <E, T>(p:Promise<E, T>,val:Validation<E,T>):Promise<E,T> 
  {
    return if (p.isComplete()) p
    else 
    {
      p.lock();
      if (!p.isCompleteDoubleCheck()) 
      {
        switch (val) 
        {
          case Success(s): for (c in p._successListeners) c(s);
          case Failure(f): for (c in p._failureListeners) c(f);
        }
        for (c in p._completeListeners) c(val);
        p._value = Some(val);
        p._complete = true;
        p.progress(1.0);
        
        
        p.clearListeners();
      }
      p.unlock();
      p;
    }
  }
  
  public static function tryFailure <E, T>(p:Promise<E, T>, f : E):Promise<E,T>  
  {
    return p.tryComplete(Failure(f));
  }

  public static function trySuccess <E, T>(p:Promise<E, T>, t : T):Promise<E,T> 
  {
    return p.tryComplete(Success(t));
  }

  public static function failure <E, T>(p:Promise<E, T>, f : E):Promise<E,T>  
  {
    return p.complete(Failure(f));
  }

  public static function success <E, T>(p:Promise<E, T>, t : T):Promise<E,T> 
  {
    return p.complete(Success(t));
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
      if (!p.isCompleteDoubleCheck()) p._completeListeners.push(f);
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

  public static function combineIterableWith <A,B,E> (a:Iterable<Promise<E,A>>, f:Iterable<A>->B):Promise<E,B>
  {
    
   
    var fut = new Promise();
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
  
  public static function combineIterable <A,E> (a:Iterable<Promise<E,A>>):Promise<E,Iterable<A>>
  {
    return combineIterableWith(a, Scuts.id);
  }
  
  public static function apply<A,B,E>(f:Promise<E,A->B>, p:Promise<E,A>):Promise<E,B> 
  {
    return zipWith(f, p, function (g, x) return g(x)); 
  }
  
  @:noUsing public static function cancelled <E,S>(e:E):Promise<E,S> {
    var p = new Promise();
    p.failure(e);
    return p;
  }
  
  @:noUsing public static function pure <E,S>(s:S):Promise<E,S> 
  {
    return new Promise().success(s);
  }
  
  @:noUsing public static function mk <E,S>():Promise<E,S> 
  {
    return new Promise();
  }

  public static function flatMap < E,S,T > (p:Promise<E,S>, f:S->Promise<E,T>):Promise<E,T>
  {
    var res = new Promise();
    
    function success(r) {
      var p1 = f(r);
      p1.onSuccess(res.success);
      p1.onProgress(function (p) res.progress(0.5 + p * 0.5));
      p1.onFailure(res.failure);
    }
    
    p.onSuccess(success)
     .onFailure(res.failure)
     .onProgress(function (p) res.progress(p * 0.5));
    
    return res;
  }
  
  public static function map < S, T,E > (p:Promise<E,S>, f:S->T):Promise<E,T>
  {
    var res = new Promise();

    
    
    
    p.onSuccess (f.next(res.success))
     .onFailure(res.failure)
     .onProgress (res.progress);
      
    return res;
  }
  
  public static function filter <E,T>(p:Promise<E,T>, f:T->Bool, failureVal:E):Promise<E, T>
  {
    var res = new Promise();
    p.onSuccess (function (x) if (f(x)) res.success(x) else res.failure(failureVal))
     .onFailure(res.failure)
     .onProgress (res.progress);
    return res;
  }
  
  public static function filterUnit <T>(p:PromiseD<T>, f:T->Bool):PromiseD<T>
  {
    return filter(p, f, Unit);
  }
  
  public static function flatten <E,T>(p:Promise<E,Promise<E,T>>):Promise<E, T>
  {
    var res = new Promise();
    
    function complete (x:Promise<E, T>) {
      x.onComplete (res.complete)
       .onProgress (res.progress);
    }
    
    p.onSuccess(complete)
    .onFailure( res.failure)
    .onProgress (res.progress);
    return res;
  }

  
  public static function then<A,B,Z> (a:Promise<Z,A>, b:Void->Promise<Z,B>):Promise<Z,B>
  {
    return a.flatMap(function (_) return b());
  }
  
  public static function zip<A,B,Z>(a:Promise<Z,A>, b:Promise<Z,B>):Promise<Z,Tup2<A,B>>
  {
    return Tup2.create.liftPromiseF2()(a,b);
  }
  
  public static function 
  zip3<A,B,C,Z>(a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>):Promise<Z,Tup3<A,B,C>>
  {
    return Tup3.create.liftPromiseF3()(a,b,c);
  }
  
  public static function 
  zip4<A,B,C,D,Z>(a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, d:Promise<Z,D>):Promise<Z,Tup4<A,B,C,D>>
  {
    return Tup4.create.liftPromiseF4()(a,b,c,d);
  }
  
  public static function 
  zipWith<A,B,C,Z>(a:Promise<Z,A>, b:Promise<Z,B>, f:A->B->C):Promise<Z,C>
  {
    return f.liftPromiseF2()(a,b);
  }
  
  public static function 
  zipWith3<A,B,C,D,Z>(a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, f:A->B->C->D):Promise<Z,D>
  {
    return f.liftPromiseF3()(a,b,c);
  }
  
  public static function 
  zipWith4<A,B,C,D,E,Z>(a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, d:Promise<Z,D>, f:A->B->C->D->E):Promise<Z,E>
  {
    return f.liftPromiseF4()(a,b,c,d);
  }
  
  public static function liftPromiseF0 <E,A> (f:Void->A):Void->Promise<E,A> 
  {
    return function () return new Promise().success(f());
  }

  public static function liftPromiseF1 <E,A, B> (f:A->B):Promise<E,A>->Promise<E,B> 
  {
    return function (a:Promise<E,A>) {
      var res = new Promise();
      a.onSuccess(f.next(res.success))
       .onFailure(res.failure)
       .onProgress(res.progress);
      return res;
    }
  }

  public static function liftPromiseF2 <A, B, C, E> (f:A->B->C):Promise<E,A>->Promise<E,B>->Promise<E,C> 
  {
    return function (a:Promise<E,A>, b:Promise<E,B>) {
      var res = new Promise();
      
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

  public static function 
  liftPromiseF3 <A, B, C, D,Z> (f:A->B->C->D):Promise<Z,A>->Promise<Z,B>->Promise<Z,C>->Promise<Z,D>
  {
    return function (a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>) {
      var res = new Promise();
      
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

  public static function 
  liftPromiseF4 <A, B, C, D, E,Z> (f:A->B->C->D->E):Promise<Z,A>->Promise<Z,B>->Promise<Z,C>->Promise<Z,D>->Promise<Z,E>
  {
    return function (a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, d:Promise<Z,D>) {
      var res = new Promise();
      
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
  
  public static function 
  liftPromiseF5 <A, B, C, D, E, F,Z> (f:A->B->C->D->E->F)
  :Promise<Z,A>->Promise<Z,B>->Promise<Z,C>->Promise<Z,D>->Promise<Z,E>->Promise<Z,F>
  {
    return function (a:Promise<Z,A>, b:Promise<Z,B>, c:Promise<Z,C>, d:Promise<Z,D>, e:Promise<Z,E>) {
      var res = new Promise();
      
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



