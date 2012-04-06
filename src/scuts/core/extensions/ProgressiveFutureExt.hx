package scuts.core.extensions;
import scuts.Assert;
import scuts.core.types.Future;
import scuts.core.types.ProgressiveFuture;

/**
 * ...
 * @author 
 */

class ProgressiveFutureExt
{

  public static function toFuture<T>(p:ProgressiveFuture<T>) :Future<T>
  {
    var fut = new Future();
    p.deliverTo(function (v) fut.deliver(v));
    p.ifCanceled(function () fut.cancel());
    return fut;
  }
  
  static function onCompleteHandler <S,T>(fut:ProgressiveFuture<Array<T>>, num:Int, all:Iterable<ProgressiveFuture<T>>, firstFutureRatio:Float) {
    if (num == 0) {
        // this sets progress to 1.0 automatically
        fut.deliver([]);
      } else {
        var allRatio = 1.0-firstFutureRatio;
        var cur = 0;
        var d = [];
        var percentages = [];
        
        function updateProgress () {
          var p = 0.0;
          for (i in percentages) p += i;
          fut.setProgress(firstFutureRatio + (p/num) * allRatio);
        }
        var z = 0;
        for (i in all) {
          
          i.deliverTo(function (r1) {
            d.push(r1);
            if (++cur == num) fut.deliver(d);
          });
          i.ifCanceled(function () {
            fut.cancel();
          });
          
          var index = z;
          percentages[index] = 0.0;
          i.onProgress(function (p) {
            percentages[index] = p;
            updateProgress();
          });
          z++;
        }
      }
  }
  
  public static function collectFromArrayToArray < S,T > (e:ProgressiveFuture<S>, f:S->Array<ProgressiveFuture<T>>, ?firstFutureRatio:Float = 0.5):ProgressiveFuture<Array<T>>
  {
    Assert.assertFloatInRange(firstFutureRatio, 0.0, 1.0);
    var fut = new ProgressiveFuture();
    
    e.deliverTo(function (r) {
      var all = f(r);
      var num = all.length;
      onCompleteHandler(fut, num, all, firstFutureRatio);
    });
    
    // we don't know how many futures are returned by f, so we cannot
    // calculate the percentage correctly. Thus the percentage for the first 
    // future can be set through firstFutureRatio
    e.onProgress(function (p) {
      fut.setProgress(p*firstFutureRatio);
    });
    
    e.ifCanceled(function () {
      fut.cancel();
    });
    return fut;
  }
  
  public static function collectFromIterableToArray < S,T > (e:ProgressiveFuture<S>, f:S->Iterable<ProgressiveFuture<T>>, ?firstFutureRatio:Float = 0.5):ProgressiveFuture<Array<T>>
  {
    Assert.assertFloatInRange(firstFutureRatio, 0.0, 1.0);
    var fut = new ProgressiveFuture();
    
    e.deliverTo(function (r) {
      var all = f(r);
      var num = { var i = 0; for (_ in all) i++; i;};
      onCompleteHandler(fut, num, all, firstFutureRatio);
    });
    // we don't know how many futures are returned by f, so we cannot
    // calculate the percentage correctly. Thus the percentage for the first 
    // future can be set through firstFutureRatio
    e.onProgress(function (p) {
      fut.setProgress(p*firstFutureRatio);
    });
    e.ifCanceled(function () {
      fut.cancel();
    });
    return fut;
  }
  
  public static function flatMap < S,T > (w:ProgressiveFuture<S>, f:S->ProgressiveFuture<T>):ProgressiveFuture<T>
  {
    var res = new ProgressiveFuture();
    w.deliverTo(function (r) 
    {
      var f1 = f(r);
      f1.deliverTo(function (r) res.deliver(r));
      
      f1.onProgress(function (p) {
        res.setProgress(0.5 + p * 0.5);
      });
      
      f1.ifCanceled(function () res.cancel());
    });
    w.ifCanceled(function () 
    {
      res.cancel();
    });
    w.onProgress(function (p) {
      res.setProgress(p * 0.5);
    });
    return res;
  }
  
  public static inline function map < S, T > (fut:ProgressiveFuture<S>, f:S->T):ProgressiveFuture<T>
  {
    var res = new ProgressiveFuture();
      
    fut.deliverTo(function (v) res.deliver(v))
     .ifCanceled(function () res.cancel())
     .onProgress(function (p) res.setProgress(p));
      
    return res;
  }
  /*
  public static inline function map2 < S1, S2, T> (a:ProgressiveFuture<S1>, f:S1->S2->T, b:ProgressiveFuture<S2>):ProgressiveFuture<T>
  {
    return f.liftWithProgressiveFuture()(a, b);
  }
  
  public static inline function map3 < S1, S2, S3, T> (a:ProgressiveFuture<S1>, f:S1->S2->S3->T, b:ProgressiveFuture<S2>, c:ProgressiveFuture<S3>):ProgressiveFuture<T>
  {
    return f.liftWithProgressiveFuture()(a, b, c);
  }
  
  public static inline function map4 < S1, S2, S3, S4, T> (a:ProgressiveFuture<S1>, f:S1->S2->S3->S4->T, b:ProgressiveFuture<S2>, c:ProgressiveFuture<S3>, d:ProgressiveFuture<S4>):ProgressiveFuture<T>
  {
    return f.liftWithProgressiveFuture()(a, b, c, d);
  }
  */
  
}