package scuts.core;

import scuts.core.Validations.Validation.Success;
import utest.Assert;


using scuts.core.Functions;
using scuts.core.Promises;

class PromisesTest
{

  public function new () {}
 
  
  public function testApply () {
    
    
    var p1 = Promises.pure(1);
    var p2 = Promises.pure(2);
    var p3 = Promises.pure(3);


    
    {
      
      function f (a:Int, b:Int, c:Int):Int {
        return a + b + c;
      }
      
      
      var result = Promises.pure(f.curry()).apply(p1).apply(p2).apply(p3);
        
      var r = 0;

      
      result.onSuccess(function (x) {

        r = x;
      });
      
      utest.Assert.same(6, r);

      
    }
    {
      function f (a:Int, b:Int, c:Int, d:Int, e:Int, f:Int):Int {
        return a + b + c + d + e + f;
      }
      
      var result = Promises.pure(f.curry()).apply(p1).apply(p2).apply(p3).apply(p1).apply(p2).apply(p3);
      
      var r = 0;
      result.onSuccess(function (x) {
        r = x;
      });
      utest.Assert.same(12, r);
    }
    
  }

  public function testCreateAndCompletePromise () 
  {
    var d = Promises.deferred();

    var z = 0;
    var y = 0;
    d.onSuccess(function (x) z = x);
    d.onFailure(function (x) y = x);

    Assert.equals(0, z);
    Assert.equals(0, y);

    d.success(10);

    Assert.equals(10, z);
    Assert.equals(0, y);

    // cannot complete again

    Assert.raises(function () d.success(34));
    Assert.raises(function () d.failure(34));    
    Assert.raises(function () d.complete(Success(1)));

  }

  public function testFlatMapSuccess () 
  {
    var d = Promises.deferred();
    var x = d.flatMap(function (x) return Promises.pure(x + 1));

    x.onSuccess(Assert.equals.bind(2, _));

    d.success(1);


  }

  public function testFlatMapError () 
  {
    var d = Promises.deferred();
    var x = d.flatMap(function (x) return Promises.pure(x + 1));

    x.onFailure(Assert.equals.bind(1, _));

    d.failure(1);
  }

  public function testFlatMapProgressSuccess () 
  {
    var d = Promises.deferred();
    var x = d.flatMap(function (x) return Promises.pure(x + 1));

    x.onProgress(Assert.equals.bind(1.0, _));

    d.success(1);
  }

  public function testFlatMapProgressError () 
  {
    var d = Promises.deferred();
    var x = d.flatMap(function (x) return Promises.pure(x + 1));

    x.onProgress(Assert.equals.bind(1.0, _));

    d.failure(1);
  }

  public function testProgress () 
  {
    var d = Promises.deferred();
    
    var x = 0.0;
    d.onProgress(function (p) x = p);

    d.progress(0.5);

    Assert.equals(0.5, x);

    d.progress(0.8);
  
    Assert.equals(0.8, x);        

    d.success(1);

    Assert.equals(1.0, x);        
  }

  public function testZip () 
  {
    var d1 = Promises.deferred();
    var d2 = Promises.deferred();

    var x = d1.zip(d2);

    var z1 = 0;
    var z2 = 0;

    x.onSuccess(function(t1,t2) { z1 = t1; z2 = t2; }.tupled());


    d1.success(1);

    Assert.equals(0, z1);
    Assert.equals(0, z2);

    d2.success(2);

    Assert.equals(1, z1);
    Assert.equals(2, z2);


  }
  
}