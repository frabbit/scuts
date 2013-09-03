package scuts.macros.builder;

#if false


import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.core.Ordering;


using scuts.core.SortToBy;
using scuts.core.Filter;

private typedef SType = scuts.mcore.Type;

class MultipleDispatchMacro 
{

  public static function make(fields:Array<Field>) 
  {
    // sort fields based on their first argument most concrete type to the head
    
    var filteredFields = fields.filter(function (f:Field) {
      return switch(f.kind) {
        case FFun(_): true;
        default: false;
      }
    });
    
    var sortedFields = filteredFields.sortToBy(function (f1:Field, f2:Field) {
      
      var t1 = switch (f1.kind) {
        case FFun(f):
          f.args[0].type;
        default: throw "assert";
      }
      var t2 = switch (f2.kind) {
        case FFun(f):
          f.args[0].type;
        default: throw "assert";
      }
      
      return SType.isSubtypeOf(t1, t2) ? Ordering.LT
          : SType.isSubtypeOf(t2, t1) ? Ordering.GT :
            Ordering.EQ;
    });
    
    trace(fields);
    
    // create tuple arguments for every function, so that it's callable with all possible tuples (multiple dispatch)
    // class Foo {
    //  foo (a:Int, b:String, c:Float):Int
    //  foo (b:String, c:Float):Int
    // }
    // becomes 
    // class Foo0_0 : foo (a:Int, b:String, c:Float):Int // original function
    // class Foo0_1 : foo (t:Tuple3<Int, String, Float>):Int { return Foo0_0.foo(t._1, t._2, t._3);} 
    // class Foo0_2 : foo (t:Tuple2<Int,String>, c:Float):Int { return Foo0_0.foo(t._1, t._2, c);} 
    // class Foo1_0 : foo (b:String, c:Float):Int // original function
    // class Foo1_1 : foo (t:Tuple2<String, Float>):Int { return Foo1_0.foo(t._1, t._2);}
    
    
    
    
  }
  
}

#end