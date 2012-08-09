package hots;
import utest.Assert;

using hots.Hots;

using hots.UnderscoreTests;
using hots.UnderscoreTests.PrivateAccess;

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
    
    Hots.implicitVal(3);
    Hots.implicitVal("foo");
    
    function add (a:Implicit<Int>) return a;
    function add2 (a:Implicit<Int>, b:Implicit<String>) return a+b;
    
    Assert.equals(3, add._());
    
    Assert.equals("3foo", add2._());

  }
  
  
  public function testOnSimpleClosure() 
  {
    
    Hots.implicitVal(3);

    Assert.equals(3, (function add (a:Implicit<Int>) return a)._());
    
  }
  
  public static inline function getVal(s:String, a:Implicit<Int>) return s.charAt(a)
  
  public function testOnInlined() 
  {
    
    Hots.implicitVal(0);

    inline function add (a:Int) return if (a == 3) "foo" else "bar";
    
    Assert.equals("f", add(3).getVal._());
    
  }
  
  public function testOnInlinedWithPrivateAccess() 
  {
    
    Hots.implicitVal(0);

    Assert.equals("f", "foo".callPublic._());
    
  }
  
}


class PrivateAccess {
  
  public static inline function callPublic (s:String, i:Implicit<Int>) {
    return callPrivate(s,i);
  }
  
  public static function callPrivate (s:String, i:Int) {
    return s.charAt(0);
  }
  
}