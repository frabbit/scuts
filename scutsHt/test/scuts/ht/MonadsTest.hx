package scuts.ht;



using scuts.ht.Context;

import scuts.core.Options;

typedef A = utest.Assert;



class MonadsTest 
{

  public function new() 
  { 
   
  }
  
  public function testArrayMonad () 
  {
    var actual = [1,2,3].map_(function (x) return x + 1);
    
    A.same([2,3,4], actual);
  }
  
  public function testChainedArrayMonad () 
  {
    var actual = [1,2,3].map_(function (x) return x + 1).map_(function (x) return x + 1);
    
    A.same([3,4,5], actual);
    
  }
  
  public function testChainedFlatMapArrayMonad () 
  {
    var actual = [1,2,3].flatMap_(function (x) return [x + 1]).flatMap_(function (x) return [x + 1]);
    
    A.same([3,4,5], actual);
    
  }
  
  public function testChainedFlatMapOptionMonad () 
  {
    var actual = Some(1).flatMap_(function (x) return Some(x + 1)).flatMap_(function (x) return Some(x + 1));
    
    A.same(Some(3), actual);
  }
  
}