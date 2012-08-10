package;




import hots.EqTest;
import hots.MonadTransformersTest;

import hots.ImplicitScopeTests;
import hots.UnderscoreTests;
import hots.MonadsTest;

import utest.Runner;
import utest.ui.Report;


class AllTests 
{
  

  public static function main() 
  {
    
    
    var runner = new Runner();
    
    runner.addCase(new ImplicitScopeTests());
    runner.addCase(new UnderscoreTests());
    runner.addCase(new MonadsTest());
    runner.addCase(new MonadTransformersTest());
    runner.addCase(new EqTest());
    

    
    Report.create(runner);
    
    runner.run();
  }
}