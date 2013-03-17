package;






import haxe.Http;
import scuts.core.Ios;

import scuts.core.Unit;
import scuts.ht.Context.Applicative;
import scuts.ht.instances.std.ContOf;
import scuts.ht.syntax.FunctorBuilder;
import scuts.core.Arrays;
using scuts.core.Promises;
import scuts.core.Tuples;





using scuts.ht.Context;
using scuts.core.Options;
using scuts.core.Validations;



import scuts.core.Iteratee;






class AllTests 
{
  
  public static function getUrl (url:String):Promise<Validation<String, String>>
  {
   
      trace("hello");
      var p = Promises.mk();
      var http = new Http(url);
      
      http.onData = function (data) {
        p.complete(Success(data));
      }
      http.onError = function (err) {
        p.complete(Failure(err));
      }
      http.request(false);
      return p;
    
  }
  
  public static function getLine ():Io<String>
  {
    return new Io(function () {
      return Sys.stdin().readLine();
    });
  }

  public static function writeLine (s:String):Io<Unit>
  {

    return new Io(function () {
      Sys.println(s);
      return Unit;
    });
  }


  public static function main() 
  {

   //1.f().foo1();
//
//   //[Success(1)].validationT().foo2();
//   //trace([Success(1), Failure(2)].validationT().map_(function (x) return x + 1));
//   //
//   //var z = [Success(1)];
//   //$type(z.validationT().map);
   //trace(z.validationT().map_(function (x) return x + 1));




   function log (s:String):Io<Unit> 
   {
    return new Io( function () {
      trace(s);
      return Unit;
    });
   }


   
   var monad = Hots.implicitByType("Monad<Of<Of<Io<In>, Promise<In>>, Validation<String, In>>>");


   var monad2 = Hots.implicitByType("Monad<OfOf<Io<In>, Promise<In>, Validation<String, In>>>");
   

   //var myMap = [1].map_(_);



   function f (a:Int, b:Int):Int return a + b;

  Hots.implicitByType("Monad<Array<In>>");   
  Hots.implicitByType("Pure<Array<In>>");
Applicative;
scuts.ht.instances.Applicatives;
   var app = Hots.implicitByType("Applicative<Array<In>>");
   trace(f.lift2(app)([1],[2]));




   monad.pure(log);
   var m = new Io(function () return Promises.pure(Success("5")));
   $type(m.promiseT().validationT());





   /*
   var getUriData = Do.run(
    urlResult <= new Io(getUrl.bind("http://haxe.googlecode.com/svn-history/r6369/trunk/optimizer.ml")),
    data <= urlResult.validationT(),
    pure(data)
    );
   
   var program = Do.run(
    
    

    input <= getLine(),
    _ <= (if (input == "yes")
      writeLine("it was yes")
    else
      writeLine("it was not yes"))
    ,
    pure(getUriData)

    pure(Unit),
    pure(Unit)
    
   );

   trace("nothing happened");
   program.toIo().unsafePerformIo();
  */




   //var vt = [Success(1)].validationT();
   //trace(vt.map_(function (x) return x + 1));
   //trace([Success(1)].validationT().map_(function (x) return x + 1));
    /*
    foo1().foo();
    //scuts.ht.core.Hots.safeCast(new MyInt(5), var _ : MyInt).foo();


    
    function f <A,B>(x:Of<MyArray<In>,A>, f:A->B):Of<MyArray<In>, B> 
      return new MyArrayOf(new MyArray(Arrays.map(x.unbox().a, f)));
    var myArrayFunctor = FunctorBuilder.createFromMap(f);

    $type(myArrayFunctor);

    Hots.implicit(myArrayFunctor);

    //Functors.map._(new MyArray([1,2]).box(), function (x) return x + 1);

    
    Some(1).map_(function (x) return x + 1);

   // trace(Some(1).map_.bind(_)(function (x) return x + 1));


    

    trace(Some(1).map_(function (x) return x + 1).map_(function (x) return x + 2));

    


  */


    // var suites = new Array();
    // suites.push(TestSuite);
    // var client = new RichPrintClient();
    // var httpClient = new HTTPClient(new SummaryReportClient());
    
    // var runner = new TestRunner(client);
    // runner.addResultClient(httpClient);

    // runner.completionHandler = completionHandler;
    // runner.run(suites);

    // new TestSuite();
    
    //var x : Of<Array<In>, Int> = [1];

    // var f = new ArrayFunctor();
    // trace("hi");
    // trace(["hi"]);
    // trace(x);
    
    // Hots.implicit(new OptionFunctor());

    
/*
    var f1 = function (x:Int) return x + 1;

    var f2 = function (x) return x + 3;

    var arrow = Hots.implicitByType("Arrow<scuts.ht.core.In->scuts.ht.core.In>");

    var f3 = f1.arr(arrow).second(arrow);
    
    trace(f3.toFunction()(Tup2.create(1,2) ));
 
    var f3 = f1.arr(arrow).second(arrow);
    

    //trace(f1.arr._().second._().toFunction()(Tup2.create(17,2)));

    trace(f3.toFunction()(Tup2.create(1,2) ));




    
    
    function z1 (x:Int->String):String return "foo";

    var c1:ContOf<Int,String> = z1;




    Some(1).map_(function (x) return x + 1);

    
    //Hots.implicit(InstMonad.arrayMonad);
    //Hots.implicit(new scuts.ht.instances.std.OptionTFunctor(new scuts.ht.instances.std.ArrayFunctor()));

    // Of<Array<In>, Void->Promise<Int>>
    //[ function () return Promises.pure(1) ].lazyT().promiseT();

    var x  = [function () return Some([1]), function () return Some([3])];

    //var xy = x.lazyT().optionT().arrayT().map._(function (x) return x+1).runT().runT().runT();



    

    
    //trace(xy[1]());
    //$type(xy.runT());

    //trace(xy());

    Hots.resolve(Functors.map, [[1]].arrayT(), function (x) return x + 1);
 
    $type([[1]].arrayT()).map_(function (x) return x + 1);

    //[[1]].arrayT().map._(function (x) return x + 1);

    [ (function () return Promises.pure(1))() ].promiseT().flatMap_(function (x) return [Promises.pure(x + 2)].promiseT());
 */ 
 /*
    trace([Promises.pure(1)].promiseT().flatMap_(function (x) return [Promises.pure(x + 1)].promiseT()));

    trace([Some(1)].optionT().flatMap_(function (x) return [Some(3)].optionT()));

    [Some(Some(1))].optionT();

    [Some(Some(1))].optionT().optionT();

    trace([Some(Some(1))].optionT().optionT().flatMap_(function (x) return [Some(Some(5))].optionT().optionT()));

    var t1 = [Some(1)].optionT();
    
    var r = t1.flatMap_(function (z:Int) {
      return [Some("hi")].optionT();
      
    });

    trace([Some(1)].optionT().runT().flatMap_(function (x) return [Some(7)]));


    
    trace(r);
    
    trace(Do.run(
      z <= [1,2],
      y <= [3,4],
      pure(z + y)
    ));
    
    trace(Do.run(
      z <= [Some(2)].optionT(),
      y <= [Some(2)].optionT(),
      pure(z + y)
    ));
    
    trace(Do.run(
      z <= Some(5),
      y <= Some(7),
      pure(z + y)
    ));

    trace(Do.run(
      z <= Promises.pure(5),
      y <= Promises.pure(7),
      pure(z + y)
    ));
  



    //trace([Some(1)].optionT().map._(function (x) return x+1));
    
    trace([[1]].arrayT().map._(function (x) return x+1));
    trace([Promises.pure(1)].promiseT().map._(function (x) return x+1));
    trace([Success(1), Failure(1)].validationT().map._(function (x) return x + 1));
    var f = [Success(1)].validationT().map;
    f._(function (x) return x + 1);
    //var m = $type([Success(1)].validationT().map);
    */
    
    //[Success(1)].validationT().map_(function (x) return x + 1);
    //trace([Success(1)].validationT().map(function (x) return x + 1, new scuts.ht.instances.std.ValidationTFunctor(new scuts.ht.instances.std.ArrayFunctor())));
  

    //trace(Hots.resolve(Some(1).map, function (x) return x + 1));
    //trace(Some(1).map._(function (x:Int) return x + 1));

    //trace(Some(1).map._(function (x:Int) return x + 1));
    
  
    
    

  }

  /*
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
  */
}



/*
class TestSuite extends massive.munit.TestSuite
{ 

  public function new()
  {
    super();

    
    
  }
}
*/


