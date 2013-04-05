package scuts.mcore;

import scuts.mcore.ast.Exprs;
import scuts.mcore.Make;
import utest.Assert;

/**
 * ...
 * @author 
 */

class MakeTest 
{

  public function new () {}

  public function testAnon() 
  {
    var field = Make.anonField("foo", Make.constIdent("a"));
    var actual = Make.anon([field]);
    
    var expected = macro { foo : a };
    
    Assert.isTrue(Exprs.eq(actual, expected, false));
  }
  
}