package scuts.core;


import scuts.core.Strings;


private typedef S = Strings;

class StringsTest 
{

  public function new () {}
  
  public function testTimesShouldReturnTheString5Times() 
  {
    var s = "a";
    utest.Assert.same(S.times(s, 5), "aaaaa");
  }
  
  
  public function testTimesShouldReturnTheString0Times() 
  {
    var s = "a";
    utest.Assert.same(S.times(s, 0), "");    
    
  }
  
}