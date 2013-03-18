package;




import scuts.ht.ImplicitInstances;



import scuts.ht.DoTest;
import scuts.ht.MonadsTest;
import scuts.ht.MonadTransformersTest;
import scuts.ht.EqTest;
#if (!cpp && !flash)
import scuts.ht.ImplicitScopeTests;
//
import scuts.ht.UnderscoreTests;
#end
import scuts.ht.instances.std.MonadLawsTest;

import scuts.ht.syntax.Monads;
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