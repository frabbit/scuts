package scuts.reactive;


using scuts.core.Functions;
using scuts.reactive.Reactive;
class ReactiveTest 
{

  public function new () { }
 
  
  public function testApply () {
    //> return f `ap` x1 `ap` ... `ap` xn is equivalent to > liftMn f x1 x2 ... xn 

    var queue = new scuts.reactive.Reactive.PriorityQueue();
    utest.Assert.same(queue.isEmpty(), true);

    queue.insert({ k: 10, v: "A" });
    utest.Assert.same(queue.isEmpty(), false);    
    utest.Assert.same(1, queue.length());

    queue.insert({ k: 2, v: "B" });
    utest.Assert.same(queue.isEmpty(), false);    
    utest.Assert.same(2, queue.length());

    queue.insert({ k: 5, v: "C" });
    utest.Assert.same(queue.isEmpty(), false);    
    utest.Assert.same(3, queue.length());

    utest.Assert.same(queue.pop().v, "B");
    utest.Assert.same(queue.isEmpty(), false);    
    utest.Assert.same(2, queue.length());

    utest.Assert.same(queue.pop().v, "C");

    queue.insert({ k: 15, v: "D" });

    utest.Assert.same(queue.pop().v, "A");
    utest.Assert.same(queue.pop().v, "D");
    utest.Assert.same(queue.isEmpty(), true);    
    utest.Assert.same(0, queue.length());
    
  }
  
}