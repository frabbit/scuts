package scuts.ht;



import utest.Assert;

using scuts.ht.Context;

using scuts.ht.UnderscoreTests;
using scuts.ht.UnderscoreTests.PrivateAccess;

class UnderscoreTests
{
  public function new () {}
  
  public function testNormalCalls() 
  {
    function foo () return 1;
    
    function add (a:Int) return a+1;
    
    Assert.equals(foo() , foo._());
    Assert.equals(add(2), add._(2));
    
  }
  public function testImplicitCalls() 
  {
    
    Hots.implicit(3);
    Hots.implicit("foo");
    
    function add (a:Int) return a;
    function add2 (a:Int, b:String) return a+b;
    
    Assert.equals(3, add._());
    
    Assert.equals("3foo", add2._());
  }
  
  public function testOnSimpleClosure() 
  {
    
    Hots.implicit(3);
    
    Assert.equals(3, (function add (a:Int) return a)._());
    
  }

  public static inline function getVal(s:String, a:Int) return s.charAt(a);

  public function testOnInlined() 
  {
    
    Hots.implicit(0);

    inline function add (a:Int) return if (a == 3) "foo" else "bar";
    
    Assert.equals("f", add(3).getVal._());
    
  }
  // Failing Test during Compile Time
  #if failing_tests
  public function testOnInlinedWithPrivateAccess() 
  {
    
    Hots.implicit(0);
    
    Assert.equals("f", "foo".callPublic._());
    
  }
  #end
  
}


class PrivateAccess {
  
  public static inline function callPublic (s:String, i:Int) {
    return callPrivate(s,i);
  }
  
  private static function callPrivate (s:String, i:Int) {
    return s.charAt(0);
  }
  
}