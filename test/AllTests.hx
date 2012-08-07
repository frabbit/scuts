package;

//import scuts.mcore.CheckTest;

//import scuts.mcore.TypeTest;

#if macro
import neko.Lib;
import neko.Sys;
import scuts.mcore.extensions.ExprDefsTest;
import scuts.mcore.ParseTest;
import scuts.mcore.CheckTest;
import scuts.mcore.TypeTest;

#else 
import scuts.mcore.Print_expr_Test;
import scuts.mcore.Print_type_Test;
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
      runner.addCase(new ExprDefsTest());
      #else
      runner.addCase(new Print_expr_Test());
      runner.addCase(new Print_type_Test());
      #end
      
      Report.create(runner);
      #if macro
      Lib.println("---------------------------------------------------------------------------------------------");
      
      #end
      runner.run();
    }
}