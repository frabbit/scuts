package scuts.mcore;


import utest.Runner;
import utest.ui.Report;

#if macro
import scuts.mcore.ImportAll;
#end

class AllTests 
{
  public static function addTests(runner:Runner)
  {
    #if macro
    runner.addCase(new scuts.mcore.ParseTest());
    runner.addCase(new scuts.mcore.CheckTest());
    runner.addCase(new scuts.mcore.TypeTest());
    runner.addCase(new scuts.mcore.ast.ExprDefsTest());
    runner.addCase(new scuts.mcore.MakeTest());
    #else
    runner.addCase(new scuts.mcore.Print_expr_Test());
    runner.addCase(new scuts.mcore.Print_type_Test());
    #end
  } 

  public static function main() 
  {
    var runner = new Runner();
    
    addTests(runner);
    Report.create(runner);
    
    runner.run();
  }
}