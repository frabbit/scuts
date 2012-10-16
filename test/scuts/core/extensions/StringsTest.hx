package scuts.core;

import scuts.core.Strings;
import utest.Assert;

private typedef S = Strings;

class StringsTest 
{

  public function new () {}
  
  public function testTimes_should_return_the_string_5_times() 
  {
    var s = "a";
    
    Assert.equals("aaaaa",S.times(s, 5));
  }
  
  public function testTimes_should_return_the_string_0_times() 
  {
    var s = "a";
    
    Assert.equals("",S.times(s, 0));
  }
  
}