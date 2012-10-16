package scuts.core;

using scuts.core.Functions;
using scuts.core.Promises;
class PromisesTest 
{

  public function new () { }
 
  
  public function testApply () {
    //> return f `ap` x1 `ap` ... `ap` xn is equivalent to > liftMn f x1 x2 ... xn 
    
    var p1 = Promises.pure(1);
    var p2 = Promises.pure(2);
    var p3 = Promises.pure(3);
    
    {
      
      function f (a:Int, b:Int, c:Int):Int {
        return a + b + c;
      }
      
      
      var result = Promises.pure(f.curry()).apply(p1).apply(p2).apply(p3);
        
      var r = 0;
      result.onComplete(function (x) {
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
      result.onComplete(function (x) {
        r = x;
      });
      
      utest.Assert.same(12, r);
    }
    
  }
  
}