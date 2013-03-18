package scuts.ht;


import org.hamcrest.core.IsEqual;
import org.hamcrest.MatchersBase;

using scuts.ht.Context;



class ImplicitScopeTests extends MatchersBase
{
  
  static function identity (a:Int) return a;
  
  @:implicit static var staticScope = 1;
  
  
  @:implicit var memberScope = 2;
  
  
  public function new () {
    super();
  }
  
  @Test
  public function testScopes() 
  {
    expectStaticScope(this);
  }
  @Test
  public function shouldUseMemberScope() 
  {
    expectMemberScope(this);
  }
  @Test
  public function shouldUseLocalScope() 
  {
    expectLocalScope(this);
  }
  @Test
  public function shouldUseLocalNestedScope() 
  {
    expectLocalNestedScope(this);
  }
  @Test
  public function shouldIgnoreLocalNestedScope() 
  {
    expectLocalNestedScopeIsIgnored(this);
  }
  @Test
  public function shouldIgnoreLocalNestedScopeAndUseStatic() 
  {
    expectLocalNestedScopeIsIgnoredAndStaticUsed(this);
  }
  
  function expectLocalScope(m:MatchersBase) 
  {
    Hots.implicit(4);

    scuts.Assert.equals(4, identity._());
    
  }
  
  function expectLocalNestedScope(m:MatchersBase) 
  {
    Hots.implicit(4);
    {
      Hots.implicit(5);
      m.assertThat(5, m.equalTo(identity._()));
      
    }
  }
  
  function expectLocalNestedScopeIsIgnored(m:MatchersBase) 
  {
    Hots.implicit(4);
    
    {
      Hots.implicit(5);
    }
    m.assertThat(4, m.equalTo(identity._()));
  }
  
  function expectMemberScope(m:MatchersBase) 
  {
    m.assertThat(memberScope, m.equalTo(identity._()));
  }
  
  static function expectStaticScope(m:MatchersBase) 
  {
    m.assertThat(staticScope, m.equalTo(identity._()));
  }
  
  static function expectLocalNestedScopeIsIgnoredAndStaticUsed(m:MatchersBase) 
  {
    {
      Hots.implicit(4);
    }
    m.assertThat(staticScope, m.equalTo(identity._()));
  }
  
  
  
}