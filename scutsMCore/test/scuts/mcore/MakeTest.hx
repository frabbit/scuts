package ;
import scuts.mcore.Make;
import utest.Assert;

/**
 * ...
 * @author 
 */

class MakeTest 
{

  public static function testAnon() 
  {
    var field = Make.anonField("foo", Make.constIdent("a"));
    Make.anon([field]);
    
    var expected = 
    
    Assert.equals(expected, actual);
  }
  
}