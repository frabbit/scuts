package;




/*

import scuts1.instances.std.ContOf;
import scuts1.syntax.FunctorBuilder;
import scuts.core.Arrays;
import scuts.core.Promises;
import scuts.core.Tuples;





using scuts1.Context;
using scuts.core.Options;
using AllTests.MyArrays;


class MyArray<T> {

  public var a : Array<T>;

  public function new (a) this.a = a;

}

abstract MyArrayOf<T>(MyArray<T>) from MyArray<T> to MyArray<T> 
{
  public inline function new (x) this = x;
  @:to public inline function toOf ():Of<MyArray<In>, T> return new Of(this);
  @:from public static inline function fromOf <T>(x:Of<MyArray<In>, T>):MyArrayOf<T> return new MyArrayOf(cast x);
}

class MyArrays {
  public inline static function unbox <T>(x:MyArrayOf<T>):MyArray<T> return x;
  public inline static function box <T>(x:MyArray<T>):MyArrayOf<T> return x;
}

*/
using AllTests.MyMacro;
abstract MyInt (Int) {
  public inline function new (i:Int) this = i;
  @:from public static inline function fromInt (i:Int) return scuts1.core.Hots.safeCast(cast i, var _ : MyInt);
}

class MyMacro {
  macro public static function foo (x:haxe.macro.Expr.ExprOf<MyInt>) {
    trace(haxe.macro.Context.typeof(x));
    return macro null;
  }
}



class AllTests 
{
  
  public static function main() 
  {
    scuts1.core.Hots.safeCast(new MyInt(5), var _ : MyInt).foo();


    /*
    function f <A,B>(x:Of<MyArray<In>,A>, f:A->B):Of<MyArray<In>, B> 
      return new MyArrayOf(new MyArray(Arrays.map(x.unbox().a, f)));
    var myArrayFunctor = FunctorBuilder.createFromMap(f);

    $type(myArrayFunctor);

    Hots.implicit(myArrayFunctor);

    //Functors.map._(new MyArray([1,2]).box(), function (x) return x + 1);

    
    Some(1).map_(function (x) return x + 1);

   // trace(Some(1).map_.bind(_)(function (x) return x + 1));


    

    trace(Some(1).map_(function (x) return x + 1).map_(function (x) return x + 2));

    





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

    

    var f1 = function (x:Int) return x + 1;

    var f2 = function (x) return x + 3;

    var arrow = Hots.implicitByType("Arrow<scuts1.core.In->scuts1.core.In>");

    var f3 = f1.arr(arrow).second(arrow);
    
    trace(f3.toFunction()(Tup2.create(1,2) ));
    
    var f3 = f1.arr(arrow).second(arrow);
    

    trace(f1.arr._().second._().toFunction()(Tup2.create(17,2)));

    trace(f3.toFunction()(Tup2.create(1,2) ));




    
    
    function z1 (x:Int->String):String return "foo";

    var c1:ContOf<Int,String> = z1;




    Some(1).map_(function (x) return x + 1);

    
    //Hots.implicit(InstMonad.arrayMonad);
    //Hots.implicit(new scuts1.instances.std.OptionTFunctor(new scuts1.instances.std.ArrayFunctor()));

    // Of<Array<In>, Void->Promise<Int>>
    //[ function () return Promises.pure(1) ].lazyT().promiseT();

    var x  = [function () return Some([1]), function () return Some([3])];

    var xy = x.lazyT().optionT().arrayT().map._(function (x) return x+1).runT().runT().runT();



    

    
    //trace(xy[1]());
    //$type(xy.runT());

    //trace(xy());

    Hots.resolve(Functors.map, [[1]].arrayT(), function (x) return x + 1);

    $type([[1]].arrayT()).map_(function (x) return x + 1);

    [[1]].arrayT().map._(function (x) return x + 1);

    [ (function () return Promises.pure(1))() ].promiseT().flatMap_(function (x) return [Promises.pure(x + 2)].promiseT());

    trace([Promises.pure(1)].promiseT().flatMap_(function (x) return [Promises.pure(x + 1)].promiseT()));

    trace([Some(1)].optionT().flatMap_(function (x) return [Some(3)].optionT()));

    [Some(Some(1))].optionT();

    [Some(Some(1))].optionT().optionT();

    trace([Some(Some(1))].optionT().optionT().flatMap_(function (x) return [Some(Some(5))].optionT().optionT()));

    var t1 = [Some(1)].optionT();
    
    var r = t1.flatMap_(function (z:Int) {
      return [Some("hi")].optionT();
      
    });




    
    trace(r);
    
    trace(Do.run(
      z <= [1,2],
      y <= [3,4],
      pure(z + y)
    ));

    
    trace(Do.run(
      z <= [Some(1)].optionT(),
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
    //trace([[1]].arrayT().map._(function (x) return x+1));
    //trace([Promises.pure(1)].promiseT().map._(function (x) return x+1));
    //trace([Success(1), Failure(1)].validationT().map._(function (x) return x + 1));
    //var f = [Success(1)].validationT().map;
    //f._(function (x) return x + 1);
    //trace([x].validationT().map._(function (x) return x + 1));
    //trace([Success(1)].validationT().map(function (x) return x + 1, new scuts1.instances.std.ValidationTFunctor(new scuts1.instances.std.ArrayFunctor())));


    //trace(Hots.resolve(Some(1).map, function (x) return x + 1));
    //trace(Some(1).map._(function (x:Int) return x + 1));

    //trace(Some(1).map._(function (x:Int) return x + 1));
    
  */
    
    

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


