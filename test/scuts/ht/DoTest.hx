package scuts.ht;

import massive.munit.Assert;
import org.hamcrest.core.IsEqual;
import org.hamcrest.MatchersBase;

using scuts.ht.Context;


class DoTest extends MatchersBase
{
  public function new () super();
  
  @:test public function testSimple() 
  {
    var r = Do.run
    (
      a <= [1],
      b <= [2],
      pure(a + b)
    );
    
    assertThat(r, equalTo([3]));
  }
  
  @Test
  public function testWithFilter() 
  {
    var r = Do.run
    (
      a <= [1,2],
      filter(a > 1),
      b <= [2],
      pure(a + b)
    );
    
    assertThat(r, equalTo([4]));
  }

  @Test
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
    
    assertThat(r, equalTo([3]));
  }
  @Test
  public function testMixed() 
  {
    var r = Do.run
    (
      a <= [1],
      [1, 2],
      pure(a)
    );
    assertThat(r, equalTo([1,1]));
  }

  @Test  
  public function testOneExpr() 
  {
    var r = Do.run
    (
      [1,2]
    );
    assertThat(r, equalTo([1,2]));
  }
  
  public function testNoAssigns() 
  {
    var r = Do.run
    (
      [1],
      [2,2],
      pure(5)
    );
    Assert.areEqual([5,5], r);
    //assertThat(r, equalTo());
  }
  
  @Test
  public function testNoAssignsNoPure() 
  {
    var r = Do.run
    (
      [1]
    );
    assertThat(r, equalTo([1]));
    
  }
}