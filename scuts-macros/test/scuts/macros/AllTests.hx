
package scuts.macros;

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

    public static function addTests (runner:Runner) {
    	#if !macro
    	runner.addCase(new ImplicitSupportTest());
    	#end
    }
}