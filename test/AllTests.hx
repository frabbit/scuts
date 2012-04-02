package;

//import scuts.mcore.CheckTest;

//import scuts.mcore.TypeTest;

#if macro
import neko.Lib;
import neko.Sys;



#else 
import scuts.core.extensions.StringExtTest;
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
      runner.addCase(new StringExtTest());
      #end
      
      Report.create(runner);
      #if macro
      Lib.println("---------------------------------------------------------------------------------------------");
      #end
      runner.run();
    }
}