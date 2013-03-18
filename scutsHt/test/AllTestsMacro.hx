package;


import neko.Lib;
import neko.Sys;




import utest.Runner;
import utest.ui.Report;



class AllTests 
{
  
  public static function main() 
    {
      var runner = new Runner();
      Report.create(runner);
      runner.run();
    }
}