package;


#if macro
import neko.Lib;
// import neko.Sys;
#else 
import scuts.reactive.BehavioursTest;
import scuts.reactive.ReactiveTest;
#end



import utest.Runner;
import utest.ui.Report;

/**
 * ...
 * @author $(DefaultUser)
 */

class AllTests 
{
  
  public static function main() 
    {
      var runner = new Runner();
      #if macro
      
      #else
      runner.addCase(new BehavioursTest());
      runner.addCase(new ReactiveTest());
      #end
      
      Report.create(runner);
      #if macro
      Lib.println("---------------------------------------------------------------------------------------------");
      #end
      runner.run();
    }
}
