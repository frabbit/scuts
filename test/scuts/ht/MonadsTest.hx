package scuts.ht;

import org.hamcrest.core.IsEqual;
import org.hamcrest.MatchersBase;

using scuts.ht.Context;

import scuts.core.Options;

typedef A = scuts.Assert;



class MonadsTest extends MatchersBase
{

  public function new() 
  { 
    super();
  }
 
  @Test
  public function testArrayMonad () 
  {
    var actual = [1,2,3].map_(function (x) return x + 1);
    
    A.same([2,3,4], actual);
  }
  
  @Test
  public function testChainedArrayMonad () 
  {
    var actual = [1,2,3].map_(function (x) return x + 1).map_(function (x) return x + 1);
    
    A.same([3,4,5], actual);
    
  }
  
  @Test
  public function testChainedFlatMapArrayMonad () 
  {
    var actual = [1,2,3].flatMap_(function (x) return [x + 1]).flatMap_(function (x) return [x + 1]);
    
    A.same([3,4,5], actual);
    
  }
  
  @Test
  public function testChainedFlatMapOptionMonad () 
  {
    var actual = Some(1).flatMap_(function (x) return Some(x + 1)).flatMap_(function (x) return Some(x + 1));
    
    A.same(Some(3), actual);
  }
}