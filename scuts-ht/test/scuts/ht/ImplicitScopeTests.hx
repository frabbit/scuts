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
    Ht.implicit(4);

    A.equals(4, identity._());
    
  }
  
  function expectLocalNestedScope() 
  {
    Ht.implicit(4);
    {
      Ht.implicit(5);
      A.equals(5, identity._());
      
    }
  }
  
  function expectLocalNestedScopeIsIgnored() 
  {
    Ht.implicit(4);
    
    {
      Ht.implicit(5);
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
      Ht.implicit(4);
    }
    A.equals(staticScope, identity._());
    
  }
  
  #end
  
}



#end