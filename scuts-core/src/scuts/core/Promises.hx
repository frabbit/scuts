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

typedef PromiseD<T> = Promise<T>;

typedef PromiseU<T> = PromiseG<Unit, T>;


typedef Promise<T> = PromiseG<Throwable, T>;

@:allow(scuts.core.Promises)
class PromiseG<Err, T>
{

  #if scuts_multithreaded
  var _mutex:Mutex;
  #end

  var _completeListeners:Array<Validation<Err, T>->Void>;
  //var _failureListeners:Array<Err->Void>;
  //var _successListeners:Array<T->Void>;

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

typedef Deferred<B> = DeferredG<Throwable, B>;

/**
 * Represents a deferred value, that must be completed.
 * It can only be created with Promises.deferred().
 *
 */
@:allow(scuts.core.Promises)
abstract DeferredG<A,B>(PromiseG<A,B>) to PromiseG<A,B>
{

  inline function new (p:PromiseG<A,B>) this = p;

  public inline function promise ():PromiseG<A,B> {
    return this;
  }
}


class PromisesBool {
  public static function and (p1:Promise<Bool>, p2:Promise<Bool>) {
    return p1.zipWith(p2, Bools.and);
  }

  public static function or (p1:Promise<Bool>, p2:Promise<Bool>) {
    return p1.zipWith(p2, Bools.or);
  }

  public static function not (p:Promise<Bool>) {
    return p.map(Bools.not);
  }
}

class PromisesOption
{

  public static function filterOption <X>(p:Promise<Option<X>>, f:X->Bool) {
    return p.map(Options.filter.bind(_, f));
  }

  public static function extractOrFail <X>(p:Promise<Option<X>>, fail:Throwable):Promise<X> {
    return p.flatMap(function (x) {
      return switch(x) {
        case Some(x): Promises.pure(x);
        case None: Promises.failed(fail);
      }
    });

  }

  public static function isSome <X>(p:Promise<Option<X>>):Promise<Bool> {
    return p.map(Options.isSome);
  }

  public static function isNone <X>(p:Promise<Option<X>>):Promise<Bool> {
    return p.map(Options.isNone);
  }

  public static function mapOption <X,Y>(p:Promise<Option<X>>, f:X->Y):Promise<Option<Y>> {
    return p.map(Options.map.bind(_, f));
  }

  public static function flatMapOption <X,Y>(p:Promise<Option<X>>, f:X->Promise<Y>):Promise<Option<Y>> {
    return p.flatMap(function (x) return switch (x) {
      case Some(x): f(x).map(Some);
      case None : Promises.pure(None);
    });
  }
}

@:allow(scuts.core.Promise, scuts.core.PromiseG)
class Promises
{

  inline static function clearListeners <T,E>(p:PromiseG<E,T>)
  {
    p._completeListeners = [];
    //p._failureListeners = [];
    p._progressListeners = [];
    //p._successListeners = [];
  }

  inline static function lock <T,E>(p:PromiseG<E,T>)
  {
    #if scuts_multithreaded
    p._mutex.acquire();
    #end
  }

  inline static function unlock <T,E>(p:PromiseG<E,T>)
  {
    #if scuts_multithreaded
    p._mutex.release();
    #end
  }

  inline static function initMutex <T,E>(p:PromiseG<E,T>)
  {
    #if scuts_multithreaded
    p._mutex = new Mutex();
    #end

  }

  inline static function isCompleteDoubleCheck<T,E>(p:PromiseG<E,T>)
  {
    #if scuts_multithreaded
    return p.isComplete();
    #else
    return false;
    #end
  }



  #if js
  public static function delay <E,T>(p:PromiseG<E,T>, timeMs:Int):PromiseG<E,T>
  {
    var p1 = deferred();
    p.onComplete(function (x) {
      haxe.Timer.delay(function () {
        p1.complete(x);
        }, timeMs);
    });
    return p1;
  }

  public static function delayF <E,T>(p:Void->PromiseG<E,T>, timeMs:Int):PromiseG<E,T>
  {
    var p1 = deferred();

    haxe.Timer.delay(function () {
      p().onComplete(function (x) {
        p1.complete(x);
      });

    }, timeMs);

    return p1;
  }
  #end


  public static function flatBranch <E,T>(p:PromiseG<E, Bool>, ifTrue:Void->PromiseG<E,T>, ifFalse:Void->PromiseG<E,T>):PromiseG<E,T>
  {
    return p.flatMap(function (x) {
      return if (x) ifTrue() else ifFalse();
    });
  }

  public static function extract <E, T>(p:PromiseG<E, T>):Validation<E, T>
  {
    return p._value.getOrError("error result is not available");
  }

  public inline static function isComplete <E,T>(p:PromiseG<E,T>) return p._complete;

  public inline static function isSuccess <E,T>(p:PromiseG<E,T>) return p._value.isSome() && p._value.extract().isSuccess();

  public inline static function isFailure <E,T>(p:PromiseG<E,T>) return p._value.isSome() && p._value.extract().isFailure();

  public static function valueOption <E,T>(p:PromiseG<E,T>):Option<Validation<E, T>> return p._value;

  public static function onProgress <E,T>(p:PromiseG<E,T>,f:Percent->Void):PromiseG<E,T>
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



  public static function progress <E,T>(p:DeferredG<E,T>,percent:Percent):DeferredG<E,T>
  {
    Assert.isTrue(percent >= 0.0 && percent <= 1.0, null);
    if (!p.isComplete()) {
      for (l in p.promise()._progressListeners) l(percent);
    }
    return asDeferred(p);
  }

  public static function complete <E, T>(p:DeferredG<E, T>,val:Validation<E,T>):DeferredG<E,T>
  {
    return if (!p.isComplete()) tryComplete(p, val) else throw "Cannot complete already completed Promise";
  }

  public static function tryComplete <E, T>(p:DeferredG<E, T>,val:Validation<E,T>):DeferredG<E,T>
  {
    return asDeferred(if (p.isComplete()) p
    else
    {
      p.lock();
      if (!p.isCompleteDoubleCheck())
      {
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

  static inline function asDeferred <A,B>(p:PromiseG<A,B>) {
    return new DeferredG(p);
  }

  public static function tryFailure <E, T>(p:DeferredG<E, T>, f : E):DeferredG<E,T>
  {
    return asDeferred(p.tryComplete(Failure(f)));
  }

  public static function trySuccess <E, T>(p:DeferredG<E, T>, t : T):DeferredG<E,T>
  {
    return asDeferred(p.tryComplete(Success(t)));
  }

  public static function failure <E, T>(p:DeferredG<E, T>, f : E):DeferredG<E,T>
  {
    return asDeferred(p.complete(Failure(f)));
  }

  public static function success <E, T>(p:DeferredG<E, T>, t : T):DeferredG<E,T>
  {
    return asDeferred(p.complete(Success(t)));
  }

  public static function onComplete <E, T>(p:PromiseG<E, T>,f:Validation<E,T>->Void)
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

  public static function onFailureVoid <E, T>(p:PromiseG<E,T>,f:Void->Void)
  {
    return onFailure(p, f.promote());
  }


  public static function onFailure <E, T>(p:PromiseG<E,T>,f:E->Void)
  {
    if (!p.isComplete())
    {
      p.lock();
      if (!p.isCompleteDoubleCheck()) p._completeListeners.push(function (x) x.eachFailure(f));
      else p.onFailure(f);
      p.unlock();
    }
    else if (p.isFailure()) f(p.extract().extractFailure());

    return p;
  }

  public static function onSuccess <E,T>(p:PromiseG<E,T>,f:T->Void):PromiseG<E,T>
  {
    if (!p.isComplete())
    {
      p.lock();
      if (!p.isCompleteDoubleCheck()) p._completeListeners.push(function (x) x.each(f));
      else p.onSuccess(f);
      p.unlock();


    } else if (p.isSuccess()) f(p.extract().extract());
    return p;
  }

  public static function toString <E,T>(p:PromiseG<E,T>) {
    return
      if (isComplete(p))       "Promise(" + p._value.extract() + ")"
      else                     "Unfullfilled Promise";
  }

  public static function asPromiseD <E,T>(p:PromiseG<E,T>):PromiseD<T> return p;
  public static function asPromiseU <E,T>(p:PromiseG<E,T>):PromiseU<T> return p.mapFailure(function (_) return Unit);


  public static function successToUnit<E,T>(p:PromiseG<E,T>):PromiseG<E,Unit> return p.map(Functions.unit.promote());


  @:noUsing public static function zipIterableWith <A,B,E> (a:Iterable<PromiseG<E,A>>, f:Iterable<A>->B):PromiseG<E,B>
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
      .onFailure(fut.tryFailure)
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

  @:noUsing public static function zipIterable <A,E> (a:Iterable<PromiseG<E,A>>):PromiseG<E,Iterable<A>>
  {
    return zipIterableWith(a, Scuts.id);
  }



  public static function apply<A,B,E>(f:PromiseG<E,A->B>, p:PromiseG<E,A>):PromiseG<E,B>
  {
    return zipWith(f, p, function (g, x) return g(x));
  }

  @:noUsing public static function cancelled <E,S>(e:E):PromiseG<E,S> {
    var p = deferred();
    p.failure(e);
    return p;
  }

  /**
    Creates a resolved promise from a validation value. Based on v it can be successful or faulty.
  **/
  @:noUsing public static function fromValidation <F,S>(v:Validation<F,S>):PromiseG<F,S>
  {
    return deferred().complete(v);
  }

  /**
    Creates a resolved promise from an option value. Based on v it can be successful (Some) or faulty (None).
  **/
  @:noUsing public static function fromOptionC <F,S>(v:Option<S>, failureValue:F):PromiseG<F,S>
  {
    var x = deferred();
    return switch (v) {
      case Some(a): x.success(a);
      case None: x.failure(failureValue);
    }

  }

  /**
    Creates a resolved, but faulty promise with the error value `f`.
  **/
  @:noUsing public static function failed <E,S>(f:E):PromiseG<E,S>
  {
    return deferred().failure(f);
  }

  /**
    Wraps/lifts a simple value into an already resolved promise.
  **/
  @:noUsing public static function pure <E,S>(s:S):PromiseG<E,S>
  {
    return deferred().success(s);
  }


  @:noUsing public static function unit <E>():PromiseG<E,Unit>
  {
    return deferred().success(Unit);
  }




  /**
    Creates a new deferred object which is an abstract wrapper around a promise. The purpose of this
    distinct type is to separate the creation from the usage of a promise. Only a Deferred Object
    can be fullfilled with the functions `success`, `failure` or `complete`.

    ```haxe
    var def = deferred();
    def.success(1);
    ```



  **/
  @:noUsing public static function deferred <E,S>():DeferredG<E,S>
  {
    return new DeferredG(new PromiseG());
  }



  public static function flatMapBoth < E,S,T,X,E2 > (p:PromiseG<E,S>, ff:E->PromiseG<E2,X>, fs:S->PromiseG<E2,X>):PromiseG<E2,X>
  {
    function f1(v:Validation<E,S>) return switch (v)
    {
      case Success(s): fs(s);
      case Failure(f): ff(f);
    }
    return flatMapValidation(p,f1);

  }



  public static function flatMapValidation < E,S,E2,S2 > (p:PromiseG<E,S>, f:Validation<E,S>->PromiseG<E2,S2>):PromiseG<E2,S2>
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

  public static function before < E,S,T > (p:PromiseG<E,S>, f:Void->PromiseG<E,T>):PromiseG<E,T>
  {
    return p.flatMap(function (_) return f());
  }

  public static function flatMap < E,S,T > (p:PromiseG<E,S>, f:S->PromiseG<E,T>):PromiseG<E,T>
  {
    var res = deferred();

    function success(r)
    {
      var p1 = f(r);
      p1.onProgress(function (p) res.progress(0.5 + p * 0.5))
        .onSuccess(res.success)
        .onFailure(res.failure);
    }

    p.onProgress(function (p) res.progress(p * 0.5))
     .onSuccess(success)
     .onFailure(res.failure);


    return res;
  }

  public static inline function flatMap2 < E,S1,S2,T > (p:PromiseG<E,Tup2<S1,S2>>, f:S1->S2->PromiseG<E,T>):PromiseG<E,T>
  {
    return flatMap(p, f.tupled());
  }

  public static inline function flatMap3 < E,S1,S2,S3,T > (p:PromiseG<E,Tup3<S1,S2,S3>>, f:S1->S2->S3->PromiseG<E,T>):PromiseG<E,T>
  {
    return flatMap(p, f.tupled());
  }

  public static inline function flatMap4 < E,S1,S2,S3,S4,T > (p:PromiseG<E,Tup4<S1,S2,S3,S4>>, f:S1->S2->S3->S4->PromiseG<E,T>):PromiseG<E,T>
  {
    return flatMap(p, f.tupled());
  }

  public static inline function flatMap5 < E,S1,S2,S3,S4,S5,T > (p:PromiseG<E,Tup5<S1,S2,S3,S4,S5>>, f:S1->S2->S3->S4->S5->PromiseG<E,T>):PromiseG<E,T>
  {
    return flatMap(p, f.tupled());
  }

  public static function tryMap < S, T,E > (p:PromiseG<E,S>, f:S->T):Promise<T>
  {
    var res = deferred();

    function fx (x) {
      try {
        res.success(f(x));
      } catch (e:Dynamic) {
        res.failure(e);
      }
    }

    p.onSuccess (fx)
     .onFailure(res.failure)
     .onProgress (res.progress);

    return res;
  }

  public static function mapValidation < S,T,E > (p:PromiseG<E,S>, f:Validation<E,S>->Validation<E, T>):PromiseG<E,T>
  {
    var res = deferred();

    p.onComplete (f.next(res.complete))
     .onProgress (res.progress);
    return res;
  }


  public static function map < S, T,E > (p:PromiseG<E,S>, f:S->T):PromiseG<E,T>
  {
    var res = deferred();

    p.onSuccess (f.next(res.success))
     .onFailure(res.failure)
     .onProgress (res.progress);

    return res;
  }

  public static inline function map2 < E,S1,S2,T > (p:PromiseG<E,Tup2<S1,S2>>, f:S1->S2->T):PromiseG<E,T> {
    return map(p, f.tupled());
  }

  public static inline function map3 < E,S1,S2,S3,T > (p:PromiseG<E,Tup3<S1,S2,S3>>, f:S1->S2->S3->T):PromiseG<E,T> {
    return map(p, f.tupled());
  }

  public static inline function map4 < E,S1,S2,S3,S4,T > (p:PromiseG<E,Tup4<S1,S2,S3,S4>>, f:S1->S2->S3->S4->T):PromiseG<E,T> {
    return map(p, f.tupled());
  }

  public static inline function map5 < E,S1,S2,S3,S4,S5,T > (p:PromiseG<E,Tup5<S1,S2,S3,S4,S5>>, f:S1->S2->S3->S4->S5->T):PromiseG<E,T> {
    return map(p, f.tupled());
  }

  public static function recover < T,E, EE > (p:PromiseG<E,T>, convert:E->T):PromiseG<E,T>
  {
    return p.flatMapValidation(function (v) return switch (v)
    {
      case Success(_): p;
      case Failure(f): Promises.pure(convert(f));
    });
  }

  public static function recoverWith < T,E,E2> (p:PromiseG<E,T>, convert:E->PromiseG<E,T>):PromiseG<E,T>
  {
    return p.flatMapValidation(function (v) return switch (v)
    {
      case Success(_): p;
      case Failure(f): convert(f);
    });
  }



  public static function mapFailure < T,E, EE > (p:PromiseG<E,T>, f:E->EE):PromiseG<EE,T>
  {
    var res = deferred();

    p.onSuccess (res.success)
     .onFailure(f.next(res.failure))
     .onProgress (res.progress);

    return res;
  }

  public static function filter <E,T>(p:PromiseG<E,T>, f:T->Bool, failureVal:E):PromiseG<E, T>
  {
    var res = deferred();
    p.onSuccess (function (x) if (f(x)) res.success(x) else res.failure(failureVal))
     .onFailure(res.failure)
     .onProgress (res.progress);
    return res;
  }

  public static inline function filterUnit <T>(p:Promise<T>, f:T->Bool):Promise<T>
  {
    return filter(p, f, Unit);
  }

  public static function flatten <E,T>(p:PromiseG<E,PromiseG<E,T>>):PromiseG<E, T>
  {
    var res = deferred();

    function complete (x:PromiseG<E, T>) {
      x.onComplete (res.complete)
       .onProgress (res.progress);
    }

    p.onSuccess(complete)
     .onFailure( res.failure)
     .onProgress (res.progress);
    return res;
  }



  public static function forceSwitchTo<A,B,Z> (p:PromiseG<Z,A>, b:Void->PromiseG<Z,B>):PromiseG<Z,B>
  {
    return p.flatMapValidation(function (_) return b());
  }
  public static function forceSwitchP<A,B,Z> (p:PromiseG<Z,A>, b:PromiseG<Z,B>):PromiseG<Z,B>
  {
    return p.flatMapValidation(function (_) return b);
  }

  public static function switchTo<A,B,Z> (a:PromiseG<Z,A>, b:Void->PromiseG<Z,B>):PromiseG<Z,B>
  {
    return a.flatMap(function (_) return b());
  }

  public static inline function switchC<A,C,Z> (a:PromiseG<Z,A>, c:C):PromiseG<Z,C>
  {
    return a.switchTo(function () return Promises.pure(c));
  }

  public static inline function switchP<A,B,Z> (a:PromiseG<Z,A>, b:PromiseG<Z,B>):PromiseG<Z,B>
  {
    return a.switchTo(function () return b);
  }

  public static inline function zip<A,B,Z>(a:PromiseG<Z,A>, b:PromiseG<Z,B>):PromiseG<Z,Tup2<A,B>>
  {
    return liftF2(Tup2.create)(a,b);
  }



  public static inline function zipAfter<A,B,Z>(a:PromiseG<Z,A>, b:Void->PromiseG<Z,B>):PromiseG<Z,Tup2<A,B>>
  {
    return a.flatMap(function (x) {
      return b().map(function (y) {
        return Tup2.create(x,y);
      });
    });
  }

  public static inline function zip3After<A,B,C,Z>(a:PromiseG<Z,A>, b:Void->PromiseG<Z,B>, c:Void->PromiseG<Z,C>):PromiseG<Z,Tup3<A,B,C>>
  {
    return a.flatMap(function (x) {
      return b().zip(c()).map2(function (y,z) {
        return Tup3.create(x,y,z);
      });
    });
  }

  public static inline function
  zip3<A,B,C,Z>(a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>):PromiseG<Z,Tup3<A,B,C>>
  {
    return liftF3(Tup3.create)(a,b,c);
  }

  public static inline function
  zip4<A,B,C,D,Z>(a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>, d:PromiseG<Z,D>):PromiseG<Z,Tup4<A,B,C,D>>
  {
    return liftF4(Tup4.create)(a,b,c,d);
  }

  public static inline function
  zip5<A,B,C,D,E,Z>(a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>, d:PromiseG<Z,D>, e:PromiseG<Z,E>):PromiseG<Z,Tup5<A,B,C,D,E>>
  {
    return liftF5(Tup5.create)(a,b,c,d,e);
  }

  public static inline function
  zipWith<A,B,C,Z>(a:PromiseG<Z,A>, b:PromiseG<Z,B>, f:A->B->C):PromiseG<Z,C>
  {
    return liftF2(f)(a,b);
  }

  public static inline function
  zipWith3<A,B,C,D,Z>(a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>, f:A->B->C->D):PromiseG<Z,D>
  {
    return liftF3(f)(a,b,c);
  }

  public static inline function
  zipWith4<A,B,C,D,E,Z>(a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>, d:PromiseG<Z,D>, f:A->B->C->D->E):PromiseG<Z,E>
  {
    return liftF4(f)(a,b,c,d);
  }
  public static inline function
  zipWith5<A,B,C,D,E,F,Z>(a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>, d:PromiseG<Z,D>, e:PromiseG<Z,E>, f:A->B->C->D->E->F):PromiseG<Z,F>
  {
    return liftF5(f)(a,b,c,d,e);
  }

  @:noUsing public static function liftF0 <E,A> (f:Void->A):Void->PromiseG<E,A>
  {
    return function () return deferred().success(f());
  }

  @:noUsing public static function liftF1 <E,A, B> (f:A->B):PromiseG<E,A>->PromiseG<E,B>
  {
    return function (a:PromiseG<E,A>) {
      var res = deferred();
      a.onSuccess(f.next(res.success))
       .onFailure(res.failure)
       .onProgress(res.progress);
      return res;
    }
  }

  @:noUsing public static function liftF2 <A, B, C, E> (f:A->B->C):PromiseG<E,A>->PromiseG<E,B>->PromiseG<E,C>
  {
    return function (a:PromiseG<E,A>, b:PromiseG<E,B>) {
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
  liftF3 <A, B, C, D,Z> (f:A->B->C->D):PromiseG<Z,A>->PromiseG<Z,B>->PromiseG<Z,C>->PromiseG<Z,D>
  {
    return function (a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>) {
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
  liftF4 <A, B, C, D, E,Z> (f:A->B->C->D->E):PromiseG<Z,A>->PromiseG<Z,B>->PromiseG<Z,C>->PromiseG<Z,D>->PromiseG<Z,E>
  {
    return function (a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>, d:PromiseG<Z,D>) {
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
  :PromiseG<Z,A>->PromiseG<Z,B>->PromiseG<Z,C>->PromiseG<Z,D>->PromiseG<Z,E>->PromiseG<Z,F>
  {
    return function (a:PromiseG<Z,A>, b:PromiseG<Z,B>, c:PromiseG<Z,C>, d:PromiseG<Z,D>, e:PromiseG<Z,E>) {
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



