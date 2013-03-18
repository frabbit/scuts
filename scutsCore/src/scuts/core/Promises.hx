package scuts.core;
import scuts.core.debug.Assert;

import scuts.core.Tuples;

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

@:allow(scuts.core.Promises)
class Promise<T> 
{
  
  #if scuts_multithreaded
  var mutex:Mutex;
  #end
  
  inline function lock () 
  {
    #if scuts_multithreaded
    mutex.acquire(); 
    #end
  }
  
  inline function unlock () 
  {
    #if scuts_multithreaded 
    mutex.release(); 
    #end
  }
  
  inline function initMutex () 
  {
    #if scuts_multithreaded
    mutex = new Mutex();
    #end
    
  }
  
  inline function isCompleteDoubleCheck() 
  {
    #if scuts_multithreaded
    return isCompleteDoubleCheck();
    #else
    return false;
    #end
  }
  
  inline function isDoneDoubleCheck() 
  {
    #if scuts_multithreaded
    return isDone();
    #else
    return false;
    #end
  }
  
  inline function isCancelledDoubleCheck() 
  {
    #if scuts_multithreaded
    return isCancelled();
    #else
    return false;
    #end
  }
  
  
  var _completeListeners:Array<T->Void>;
  var _cancelListeners:Array<Void->Void>;
  
  var _progressListeners:Array<Percent->Void>;
  
  var _value:Option<T>;
  var _complete:Bool;
  var _cancelled:Bool;

  
  public function new () 
  {
    initMutex();
    
    _complete = false;
    _cancelled = false;
    _value = None;
    
    clearListeners();
  }
  
  function clearListeners () 
  {
    _completeListeners = [];
    _cancelListeners = [];
    _progressListeners = [];
  }

  /*
  public function await ():T {
    
  }
  */

}

class Promises
{
  
  public static function extract <T>(p:Promise<T>):T 
  {
    return p._value.getOrError("error result is not available");
  }

  public inline static function isComplete <T>(p:Promise<T>) return p._complete;
  
  public inline static function isCancelled <T>(p:Promise<T>) return p._cancelled;
  
  public inline static function isDone <T>(p:Promise<T>) return isComplete(p) || isCancelled(p);
  
  public static function valueOption <T>(p:Promise<T>):Option<T> return p._value;

  public static function onProgress <T>(p:Promise<T>,f:Percent->Void):Promise<T> 
  {
    if (isComplete(p)) f(1.0)
    else if (!isCancelled(p)) 
    {
      p.lock();
      if (!p.isDoneDoubleCheck()) p._progressListeners.push(f)
      else p.onProgress(f);
      p.unlock();
    } 
    return p;
  }
  
  public static function progress <T>(p:Promise<T>,percent:Percent):Promise<T>
  {
    Assert.isTrue(percent >= 0.0 && percent <= 1.0, null);
    for (l in p._progressListeners) l(percent);
    return p;
  }

  public static function complete <T>(p:Promise<T>,val:T):Promise<T> 
  {
    return if (isDone(p)) p
    else 
    {
      p.lock();
      if (!p.isDoneDoubleCheck()) 
      {
        p._value = Some(val);
        p._complete = true;
        
        p.progress(1.0);
        
        for (c in p._completeListeners) c(val);
        
        p.clearListeners();
      }
      p.unlock();
      p;
    }
  }
  

  public static function cancel <T>(p:Promise<T>):Bool 
  {
    return if (!isComplete(p) && !isCancelled(p)) 
    {
      p.lock(); 
      if (!p.isDoneDoubleCheck()) 
      {
        p._cancelled = true;
        
        for (c in p._cancelListeners) c();

        p.clearListeners();
      }
      p.unlock();
      p.isCancelled();
    } 
    else false;
  }
  
  public static function onComplete <T>(p:Promise<T>,f:T->Void) 
  {
    if (p.isComplete()) 
    {
      f(p.extract());
    } 
    else if (!p.isCancelled()) 
    {
      p.lock();
      if (!p.isDoneDoubleCheck()) p._completeListeners.push(f);
      else p.onComplete(f);
      p.unlock();
    } 
    
    return p;
  }
  
  public static function onCancelled <T>(p:Promise<T>,f:Void->Void) 
  {
    if (!p.isComplete()) 
    {
      if (p.isCancelled()) f();
      else 
      {
        p.lock();
        if (!p.isDoneDoubleCheck()) p._cancelListeners.push(f);
        else p.onCancelled(f);
        p.unlock();
      }
    }
    return p;
  }

  public static function toString <T>(p:Promise<T>) {
    return 
      if (isComplete(p))       "Promise(" + p._value + ")"
      else if (isCancelled(p)) "Cancelled Promise";
      else                     "Unfullfilled Promise";
  }

  public static function combineIterableWith <A,B> (a:Iterable<Promise<A>>, f:Iterable<A>->B):Promise<B>
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
        fut.complete(f(res));
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
    var cancel = function () {
      //trace("cancel");
      fut.cancel();
    }
    for (f in a) {
      var index = x;
      progs[index] = 0.0;
      f.onComplete(function (v) { 
        if (res[index] != null) throw "ERROR";
        res[index] = v; 
        
        count++; 
        check(); 
        } );
      f.onCancelled(cancel);
      f.onProgress(function (p) {
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
  
  public static function combineIterable <A> (a:Iterable<Promise<A>>):Promise<Iterable<A>>
  {
    return combineIterableWith(a, Scuts.id);
  }
  
  public static function apply<A,B>(f:Promise<A->B>, p:Promise<A>):Promise<B> 
  {
    return zipWith(f, p, function (g, x) return g(x)); 
  }
  
  @:noUsing public static function cancelled <S>():Promise<S> {
    var p = new Promise();
    p.cancel();
    return p;
  }
  
  @:noUsing public static function pure <S>(s:S):Promise<S> 
  {
    return new Promise().complete(s);
  }
  
  @:noUsing public static function mk <S>():Promise<S> 
  {
    return new Promise();
  }

  public static function flatMap < S,T > (p:Promise<S>, f:S->Promise<T>):Promise<T>
  {
    var res = new Promise();
    
    function complete(r) {
      var p1 = f(r);
      p1.onComplete(res.complete);
      p1.onProgress(function (p) res.progress(0.5 + p * 0.5));
      p1.onCancelled(res.cancel);
    }
    
    p.onComplete(complete)
     .onCancelled(res.cancel)
     .onProgress(function (p) res.progress(p * 0.5));
    
    return res;
  }
  
  public static function map < S, T > (p:Promise<S>, f:S->T):Promise<T>
  {
    var res = new Promise();

    trace(f);
    trace(res.complete);
    var x = f.next(res.complete);
    trace(p);
    p.onComplete (x)
     .onCancelled(res.cancel)
     .onProgress (res.progress);
      
    return res;
  }
  
  
  public static function filter <T>(p:Promise<T>, f:T->Bool):Promise<T>
  {
    var res = new Promise();
    p.onComplete (function (x) if (f(x)) res.complete(x) else res.cancel())
     .onCancelled(res.cancel)
     .onProgress (res.progress);
    return res;
  }
  
  public static function flatten <T>(p:Promise<Promise<T>>):Promise<T>
  {
    var res = new Promise();
    
    function complete (x:Promise<T>) {
      x.onComplete (res.complete)
       .onCancelled(res.cancel)
       .onProgress (res.progress);
    }
    
    p.onComplete(complete)
    .onCancelled(res.cancel)
    .onProgress (res.progress);
    return res;
  }

  public static function then<A,B> (a:Promise<A>, b:Void->Promise<B>):Promise<B>
  {
    return a.flatMap(function (_) return b());
  }
  
  public static function zip<A,B>(a:Promise<A>, b:Promise<B>):Promise<Tup2<A,B>>
  {
    return Tup2.create.liftPromiseF2()(a,b);
  }
  
  public static function 
  zip3<A,B,C>(a:Promise<A>, b:Promise<B>, c:Promise<C>):Promise<Tup3<A,B,C>>
  {
    return Tup3.create.liftPromiseF3()(a,b,c);
  }
  
  public static function 
  zip4<A,B,C,D>(a:Promise<A>, b:Promise<B>, c:Promise<C>, d:Promise<D>):Promise<Tup4<A,B,C,D>>
  {
    return Tup4.create.liftPromiseF4()(a,b,c,d);
  }
  
  public static function 
  zipWith<A,B,C>(a:Promise<A>, b:Promise<B>, f:A->B->C):Promise<C>
  {
    return f.liftPromiseF2()(a,b);
  }
  
  public static function 
  zipWith3<A,B,C,D>(a:Promise<A>, b:Promise<B>, c:Promise<C>, f:A->B->C->D):Promise<D>
  {
    return f.liftPromiseF3()(a,b,c);
  }
  
  public static function 
  zipWith4<A,B,C,D,E>(a:Promise<A>, b:Promise<B>, c:Promise<C>, d:Promise<D>, f:A->B->C->D->E):Promise<E>
  {
    return f.liftPromiseF4()(a,b,c,d);
  }
  
  public static function liftPromiseF0 <A> (f:Void->A):Void->Promise<A> 
  {
    return function () return new Promise().complete(f());
  }

  public static function liftPromiseF1 <A, B> (f:A->B):Promise<A>->Promise<B> 
  {
    return function (a:Promise<A>) {
      var res = new Promise();
      a.onComplete(f.next(res.complete))
       .onCancelled(res.cancel)
       .onProgress(res.progress);
      return res;
    }
  }

  public static function liftPromiseF2 <A, B, C> (f:A->B->C):Promise<A>->Promise<B>->Promise<C> 
  {
    return function (a:Promise<A>, b:Promise<B>) {
      var res = new Promise();
      
      var valA = None;
      var valB = None;
      
      function check () if (valA.isSome() && valB.isSome()) {
        res.complete(f(valA.extract(), valB.extract()));
      }
      
      function progress (p:Float) res.progress(p * 0.5);
      
      a.onComplete(function (r) { valA = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);
      b.onComplete(function (r) { valB = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);

      return res;
    }
  }

  public static function 
  liftPromiseF3 <A, B, C, D> (f:A->B->C->D):Promise<A>->Promise<B>->Promise<C>->Promise<D>
  {
    return function (a:Promise<A>, b:Promise<B>, c:Promise<C>) {
      var res = new Promise();
      
      var valA = None;
      var valB = None;
      var valC = None;
      
      function check () if (valA.isSome() && valB.isSome() && valC.isSome()) {
        res.complete(f(valA.extract(), valB.extract(), valC.extract()));
      }

      function progress (p:Float) res.progress(p * (1 / 3));
      
      a.onComplete(function (r) { valA = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);
      b.onComplete(function (r) { valB = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);
      c.onComplete(function (r) { valC = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);
      
      return res;
    }
  }

  public static function 
  liftPromiseF4 <A, B, C, D, E> (f:A->B->C->D->E):Promise<A>->Promise<B>->Promise<C>->Promise<D>->Promise<E>
  {
    return function (a:Promise<A>, b:Promise<B>, c:Promise<C>, d:Promise<D>) {
      var res = new Promise();
      
      var valA = None;
      var valB = None;
      var valC = None;
      var valD = None;
      
      function check () if (valA.isSome() && valB.isSome() && valC.isSome() && valD.isSome()) {
        res.complete(f(valA.extract(), valB.extract(), valC.extract(), valD.extract()));
      }

      function progress (p:Float) res.progress(p * 0.25);
      
      a.onComplete(function (r) { valA = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);
      b.onComplete(function (r) { valB = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);
      c.onComplete(function (r) { valC = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);
      d.onComplete(function (r) { valD = Some(r); check(); }).onCancelled(res.cancel).onProgress(progress);

      return res;
    }
  }
  
  public static function 
  liftPromiseF5 <A, B, C, D, E, F> (f:A->B->C->D->E->F)
  :Promise<A>->Promise<B>->Promise<C>->Promise<D>->Promise<E>->Promise<F>
  {
    return function (a:Promise<A>, b:Promise<B>, c:Promise<C>, d:Promise<D>, e:Promise<E>) {
      var res = new Promise();
      
      var valA = None;
      var valB = None;
      var valC = None;
      var valD = None;
      var valE = None;
      
      function check () if (valA.isSome() && valB.isSome() && valC.isSome() && valD.isSome() && valE.isSome()) {
        res.complete(f(valA.extract(), valB.extract(), valC.extract(), valD.extract(), valE.extract()));
      }

      function progress (p:Float) res.progress(p * 0.2);
      
      a.onComplete(function (r) { valA = Some(r); check(); } ).onCancelled(res.cancel).onProgress(progress);
      b.onComplete(function (r) { valB = Some(r); check(); } ).onCancelled(res.cancel).onProgress(progress);
      c.onComplete(function (r) { valC = Some(r); check(); } ).onCancelled(res.cancel).onProgress(progress);
      d.onComplete(function (r) { valD = Some(r); check(); } ).onCancelled(res.cancel).onProgress(progress);
      e.onComplete(function (r) { valE = Some(r); check(); } ).onCancelled(res.cancel).onProgress(progress);
      
      return res;
    }
  }
}



