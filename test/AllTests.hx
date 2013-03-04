package;

import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.SummaryReportClient;
import massive.munit.TestRunner;

import ImportAll;

//import scuts.core.StringsTest;
//import scuts.core.PromisesTest;


import massive.munit.TestSuite;

class AllTests 
{
  
  public static function main() 
  {
    var suites = new Array();
    suites.push(TestSuite);
    var client = new RichPrintClient();
    var httpClient = new HTTPClient(new SummaryReportClient());
    
    var runner = new TestRunner(client);
    runner.addResultClient(httpClient);

    runner.completionHandler = completionHandler;
    runner.run(suites);
  }

  private static function completionHandler(successful:Bool):Void
  {
    try
    {
      #if flash
      flash.external.ExternalInterface.call("testResult", successful);
      #elseif js
      js.Lib.eval("testResult(" + successful + ");");
      #else
      Sys.exit(0);
      #end
    }
    // if run from outside browser can get error which we can ignore
    catch (e:Dynamic) {}
  }
}




class TestSuite extends massive.munit.TestSuite
{ 

  public function new()
  {
    super();
    add(scuts.core.PromisesTest);
    add(scuts.core.StringsTest);
  }
}