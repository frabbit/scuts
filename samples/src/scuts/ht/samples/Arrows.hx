package scuts.ht.samples;

#if !excludeHtSamples


import scuts.core.Tuples.*;
import scuts.core.Tuples;
using scuts.ht.Context;

class Arrows 
{

  public static function plus(a:Int, b:Int):String {
    return a + "" + b;
  } 

  public static function main() 
  {
  	


    var f = function (x:Int) return x + 2;
    var g = function (x:Int) return x + 3;


    var z = f.arr_().split_(f.arr_()).runArrow();


    trace(z(tup2(1,1)));

  }
  
}


#end