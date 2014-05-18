package scuts.ht.samples;

#if !excludeHtSamples


import scuts.core.Tuples.*;
import scuts.core.Tuples;
using scuts.ht.Context;

class ArrowSample 
{

  public static function plus(a:Int, b:Int):String {
    return a + "" + b;
  } 

  public static function main() 
  {
  	
    var f = function (x) return x + 2;
    var g = function (x) return x + 3;
    

    var a1 = f.arr_().split_(f.arr_()).runArrow();

    trace(a1(tup2(1,1)));

    var a2 = f.arr_().next_(g.arr_()).runArrow();

    trace(a2(1));


    var a3 = a2.arr_().fanout_(g.arr_()).runArrow();

    trace(a3(1));



  }
  
}


#end