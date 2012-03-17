package;

//import scuts.mcore.CheckTest;

//import scuts.mcore.TypeTest;

#if macro
import hots.macros.utils.UtilsTest;

import neko.Lib;
import neko.Sys;
#else 

import hots.macros.BoxTest;
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
      runner.addCase(new UtilsTest());
      
      #else
      runner.addCase(new BoxTest());
      
      #end
      
      Report.create(runner);
      #if macro
      Lib.println("---------------------------------------------------------------------------------------------");
      
      #end
      runner.run();
    }
}