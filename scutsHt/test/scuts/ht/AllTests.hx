package scuts.ht;

import utest.Runner;
import utest.ui.Report;

#if (!macro && !excludeImportAll)
import scuts.ht.ImportAll;
#end 

class AllTests 
{
  
  public static function main() 
  {
    var runner = new Runner();
    
    addTests(runner);
    
    Report.create(runner);
    
    runner.run();
  }

  public static function addTests(runner:Runner) 
  {
    #if (!macro)
    runner.addCase(new scuts.ht.DoTest());
    runner.addCase(new scuts.ht.EqTest());
    runner.addCase(new scuts.ht.ImplicitScopeTests());
    runner.addCase(new scuts.ht.instances.MonadLawsTest());
    runner.addCase(new scuts.ht.MonadsTest());
    runner.addCase(new scuts.ht.MonadTransformersTest());
    #if heavy
    runner.addCase(new scuts.ht.MonadTransformersTestHeavy());
    #end
    runner.addCase(new scuts.ht.UnderscoreTests());
    #end
    
  } 


}
