package scuts.reactive;

import utest.Runner;
import utest.ui.Report;

#if standaloneTest
import scuts.reactive.ImportAll;
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
    #if !macro
    runner.addCase(new scuts.reactive.BehavioursTest());
    runner.addCase(new scuts.reactive.ReactiveTest());
    #end
  } 


}
