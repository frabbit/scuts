package ;



import hots.box.ArrayBox;
import hots.box.OptionBox;
import hots.classes.Monad;
import hots.classes.Monad;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.classes.Show;
import hots.classes.ShowAbstract;
import hots.extensions.Arrows;
import hots.extensions.Monads;
import hots.extensions.Monoids;
import hots.extensions.Shows;
import hots.Hots;
import hots.Implicit;
import hots.ImplicitObject;
import hots.In;
import hots.instances.ArrayOf;
import hots.instances.IntProductMonoid;
import hots.Of;
import scuts.core.extensions.Arrays;
import scuts.core.types.Option;
import scuts.macros.Do;


using scuts.core.extensions.Arrays;

using hots.Hots;

//using hots.box.ArrayBox;
using hots.box.OptionBox;

using hots.extensions.Monoids;

using scuts.core.extensions.Functions;

using scuts.core.extensions.Options;

using hots.extensions.Arrows;

import scuts.core.types.Validation;



class UsingInt {
  
  public static inline function func (a:String):Int {
    return hey();
  }
  public static inline function func2 (a:String):String {
    return hey2(a);
  }
   public static inline function func3 (a:String, b:Int, c:Int):String {
    return hey2(a);
  }
  
  static function hey2 (a:String):String {
    return a;
  }
  
  static function hey ():Int {
    return dup;
  }
  
  static var dup = 4;
  
}

using UnderscoreSample.UsingInt;


class UnderscoreSample 
{
  //static var myInt : Implicit<Int> = 3;
  
  
  //var myInstanceInt : Implicit<Int> = 2;
  
  static function test (a:Implicit<Int>) {
    return a;
  }
  
  
  function new () {


  }
  
  static function take1 (v:ImplicitObject<Monoid<Option<Int>>>) {
    
  }
  
  static function take2 (v:ImplicitObject<Semigroup<Option<Int>>>) {
    
  }
  
  
  public static function main () 
  {
    
    var z :ImplicitObject<Monoid<Option<Int>>> = null;
    
    take2(z);
    
    /*
    trace("hi".func._());
    trace(UsingInt.func._("hi"));
    trace("hi".func3._(1,2));
    */
    // underscore macro, automatically applies implicits
    
    
    
    Hots.implicit(IntProductMonoid.get());
    
    
    
    Success(5).append._(Failure(2));
    
    trace([1,2].append._([1,2]));
    trace(Some(1).append._(Some(3)));

    var x = [1,2,3]
    .flatMap._(function (x) return [x + 1, x + 2])
    .map._(function (i) return "hello" + i)
    .map._(function (i) return "hello" + i)
    .map._(function (i) return "hello" + i)
    .map._(function (i) return "hello" + i);
    
    
    trace(x);
    
    //new UnderscoreSample();
    
    
    
    
    
    
  }
  
  
}
