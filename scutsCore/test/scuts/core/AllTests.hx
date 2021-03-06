package scuts.core;


import utest.Runner;
import utest.ui.Report;

#if (!macro && !excludeImportAll)
import scuts.core.ImportAll;
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

    public static function addTests (runner:Runner) {
    	#if !macro
    	runner.addCase(new scuts.core.PromisesTest());
    	runner.addCase(new scuts.core.StringsTest());
    	#end
    }
}