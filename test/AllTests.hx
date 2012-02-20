package;

//import scuts.mcore.CheckTest;

//import scuts.mcore.TypeTest;

#if macro
import neko.Lib;
import neko.Sys;
import scuts.mcore.ParseTest;
import scuts.mcore.CheckTest;
import scuts.mcore.TypeTest;
#else 
import scuts.mcore.PrintTest;
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
      runner.addCase(new ParseTest());
      runner.addCase(new CheckTest());
      runner.addCase(new TypeTest());
      #else
      runner.addCase(new PrintTest());
      #end
      
      Report.create(runner);
      #if macro
      Lib.println("---------------------------------------------------------------------------------------------");
      
      #end
      runner.run();
    }
}