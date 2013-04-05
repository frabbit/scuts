package scuts;

import utest.Runner;
import utest.ui.Report;

class AllTests 
{
  public static function main() 
  {
    var runner = new Runner();
    
    addTests(runner);
    
    Report.create(runner);
    
    runner.run();
  }

  public static function addTests (runner:Runner) 
  {
  	scuts.core.AllTests.addTests(runner);
    scuts.mcore.AllTests.addTests(runner);
    scuts.reactive.AllTests.addTests(runner);
    scuts.macros.AllTests.addTests(runner);
    scuts.ds.AllTests.addTests(runner);
    scuts.ht.AllTests.addTests(runner);
  }
}