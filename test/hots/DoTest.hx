package hots;
import hots.Do;
import utest.Assert;

using hots.ImplicitCasts;
using hots.ImplicitInstances;

class DoTest 
{
  public function new () { }
  
  public function testSimple() 
  {
    var r = Do.run
    (
      a <= [1],
      b <= [2],
      pure(a + b)
    );
    
    Assert.same(r, [3]);
  }
  
  public function testWithFilter() 
  {
    var r = Do.run
    (
      a <= [1,2],
      filter(a > 1),
      b <= [2],
      pure(a + b)
    );
    
    Assert.same(r, [4]);
  }
  
  public function testWithMultipleFilter() 
  {
    var r = Do.run
    (
      a <= [1,2],
      filter(a > 1),
      b <= [1, 2],
      filter(b < 2),
      pure(a + b)
    );
    
    Assert.same(r, [3]);
  }
  
  public function testMixed() 
  {
    var r = Do.run
    (
      a <= [1],
      [1, 2],
      pure(a)
    );
    
    Assert.same(r, [1,1]);
  }
  
  public function testOneExpr() 
  {
    var r = Do.run
    (
      [1,2]
    );
    
    Assert.same(r, [1,2]);
  }
  
  public function testNoAssigns() 
  {
    var r = Do.run
    (
      [1],
      [2,2],
      pure(5)
    );
    
    Assert.same(r, [5,5]);
  }
  
  public function testNoAssignsNoPure() 
  {
    var r = Do.run
    (
      [1]
    );
    
    Assert.same(r, [1]);
  }
}