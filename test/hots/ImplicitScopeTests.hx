package hots;
import utest.Assert;

using hots.Hots;

private typedef A = utest.Assert;

class ImplicitScopeTests
{
  
  static function identity (a:Implicit<Int>) return a
  
  static var staticScope:Implicit<Int> = 1;
  
  
  var memberScope:Implicit<Int> = 2;
  
  
  public function new () {
    
  }
  
  public function testScopes() 
  {
    expectStaticScope();
    expectMemberScope();
    expectLocalScope();
    expectLocalNestedScope();
    expectLocalNestedScopeIsIgnored();
    expectLocalNestedScopeIsIgnoredAndStaticUsed();
  }
  
  function expectLocalScope() 
  {
    Hots.implicitVal(4);
    A.equals(4, identity._());
  }
  
  function expectLocalNestedScope() 
  {
    Hots.implicitVal(4);
    {
      Hots.implicitVal(5);
      A.equals(5, identity._());
    }
  }
  
  function expectLocalNestedScopeIsIgnored() 
  {
    Hots.implicitVal(4);
    
    {
      Hots.implicitVal(5);
    }
    
    A.equals(4, identity._());
  }
  
  function expectMemberScope() 
  {
    A.equals(memberScope, identity._());
  }
  
  static function expectStaticScope() 
  {
    A.equals(staticScope, identity._());
  }
  
  static function expectLocalNestedScopeIsIgnoredAndStaticUsed() 
  {
    {
      Hots.implicitVal(4);
    }
    A.equals(staticScope, identity._());
  }
  
  
  
}