package;




import hots.ImplicitInstances;



import hots.DoTest;
import hots.MonadsTest;
import hots.MonadTransformersTest;
import hots.EqTest;
#if (!cpp && !flash)
import hots.ImplicitScopeTests;
//
import hots.UnderscoreTests;
#end
import hots.instances.MonadLawsTest;

import hots.extensions.Monads;
import utest.Runner;
import utest.ui.Report;


class AllTests 
{
  

  public static function main() 
  {
    
     
    var runner = new Runner();
    
    runner.addCase(new MonadsTest());
    #if (!cpp && !flash)
    runner.addCase(new ImplicitScopeTests());
    runner.addCase(new UnderscoreTests());
    #end
    runner.addCase(new MonadTransformersTest());
    runner.addCase(new EqTest());
    runner.addCase(new MonadLawsTest());
    runner.addCase(new DoTest());
    

    
    Report.create(runner);
    
    runner.run();
  }
}