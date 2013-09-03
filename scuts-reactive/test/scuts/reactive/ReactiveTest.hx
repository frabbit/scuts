package scuts.reactive;


using scuts.core.Functions;
using scuts.reactive.Reactive;

private typedef A = utest.Assert;

class ReactiveTest 
{

  public function new () { }
 
  
  public function testPriorityQueue () {
    //> return f `ap` x1 `ap` ... `ap` xn is equivalent to > liftMn f x1 x2 ... xn 

    var queue = new scuts.reactive.Reactive.PriorityQueue();
    A.same(queue.isEmpty(), true);

    queue.insert({ k: 10, v: "A" });
    A.same(queue.isEmpty(), false);    
    A.same(1, queue.length());

    queue.insert({ k: 2, v: "B" });
    A.same(queue.isEmpty(), false);    
    A.same(2, queue.length());

    queue.insert({ k: 5, v: "C" });
    A.same(queue.isEmpty(), false);    
    A.same(3, queue.length());

    A.same(queue.pop().v, "B");
    A.same(queue.isEmpty(), false);    
    A.same(2, queue.length());

    A.same(queue.pop().v, "C");

    queue.insert({ k: 15, v: "D" });

    A.same(queue.pop().v, "A");
    A.same(queue.pop().v, "D");
    A.same(queue.isEmpty(), true);    
    A.same(0, queue.length());
    
  }
  
}