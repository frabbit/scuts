package;


#if macro
import neko.Lib;
import neko.Sys;
#else 
import scuts.reactive.BehavioursTest;
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
      #end
      
      Report.create(runner);
      #if macro
      Lib.println("---------------------------------------------------------------------------------------------");
      #end
      runner.run();
    }
}