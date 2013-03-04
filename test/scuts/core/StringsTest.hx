package scuts.core;

import org.hamcrest.MatchersBase;
import scuts.core.Strings;


private typedef S = Strings;

class StringsTest extends MatchersBase
{

  
  @Test
  public function times_should_return_the_string_5_times() 
  {
    var s = "a";
    assertThat(S.times(s, 5), equalTo("aaaaa"));

    
  }
  
  @Test
  public function times_should_return_the_string_0_times() 
  {
    var s = "a";
    assertThat(S.times(s, 0), equalTo(""));    
    
  }
  
}