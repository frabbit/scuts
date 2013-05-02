package scuts.ht;


#if !macro

using scuts.ht.Context;

private typedef A = utest.Assert;


class ImplicitScopeTests 
{
  public function new () {
    
  }

  #if !excludeHtTests
  static function identity (a:Int) return a;
  
  @:implicit static var staticScope = 1;
  
  
  @:implicit var memberScope = 2;
  
  
  
  
  
  
  public function testScopes() 
  {
    expectStaticScope();
  }
  
  public function testShouldUseMemberScope() 
  {
    expectMemberScope();
  }
  
  public function testShouldUseLocalScope() 
  {
    expectLocalScope();
  }
  
  public function testShouldUseLocalNestedScope() 
  {
    expectLocalNestedScope();
  }
  
  public function testShouldIgnoreLocalNestedScope() 
  {
    expectLocalNestedScopeIsIgnored();
  }
  
  public function testShouldIgnoreLocalNestedScopeAndUseStatic() 
  {
    expectLocalNestedScopeIsIgnoredAndStaticUsed();
  }
  
  function expectLocalScope() 
  {
    Hots.implicit(4);

    A.equals(4, identity._());
    
  }
  
  function expectLocalNestedScope() 
  {
    Hots.implicit(4);
    {
      Hots.implicit(5);
      A.equals(5, identity._());
      
    }
  }
  
  function expectLocalNestedScopeIsIgnored() 
  {
    Hots.implicit(4);
    
    {
      Hots.implicit(5);
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
      Hots.implicit(4);
    }
    A.equals(staticScope, identity._());
    
  }
  
  #end
  
}



#end