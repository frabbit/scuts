package scuts.core.reactive;


using scuts.core.Functions;
using scuts.core.reactive.Behaviours;
class BehavioursTest 
{

  public function new () { }
 
  
  public function testApply () {
    //> return f `ap` x1 `ap` ... `ap` xn is equivalent to > liftMn f x1 x2 ... xn 
    
    
    
    
    var p1 = Behaviours.pure(1);
    var p2 = Behaviours.pure(2);
    var p3 = Behaviours.pure(3);

    {
      function f (a:Int, b:Int, c:Int):Int {
        return a + b + c;
      }

      var result = Behaviours.pure(f.curry()).apply(p1).apply(p2).apply(p3);
        
      var r = result.get();
      
      
      utest.Assert.same(6, r);
    }
    {
      function f (a:Int, b:Int, c:Int, d:Int, e:Int, f:Int):Int {
        return a + b + c + d + e + f;
      }
      
      var result = Behaviours.pure(f.curry()).apply(p1).apply(p2).apply(p3).apply(p1).apply(p2).apply(p3);
      
      var r = result.get();
      
      
      utest.Assert.same(12, r);
    }
    
  }
  
}