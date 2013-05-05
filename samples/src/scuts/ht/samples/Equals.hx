package scuts.ht.samples;

#if !excludeHtSamples

import scuts.ht.syntax.Eqs;
import scuts.ht.syntax.EqBuilder;

import scuts.core.Tuples.*;

import scuts.core.Validations;
import scuts.core.Options;

// bring base type classes into scope

using scuts.ht.Context;

typedef Point = {
  x:Int,
  y:Int
}

class Equals 
{
  public static function main() 
  {

    // compare basic types physically

    trace(1.eq_(2));
    trace("hey".eq_("hey"));
    trace(["hey"].eq_(["hey"]));
    trace(Some(["hey"]).eq_(Some(["hey"])));
    trace(Some(["hey"]).eq_(Some(["hey"])));
    trace(tup2(1, Some(["hey"])).eq_(tup2(1, Some(["hey"]))));


    // write your own compare functions

    function eqPoint (a:Point,b:Point) return a.x.eq_(b.x) && a.y.eq_(b.y);
    
    // and bring them in scope
    Ht.implicit(EqBuilder.create(eqPoint));
    
    // type classes compose

    var x1 = tup3("hi", 1, { x : 10, y: 15 } );
    var x2 = tup3("hi", 1, { x : 10, y: 15 } );
    var x3 = tup3("hi", 1, { x : 7, y: 15 } );
    
    var z1 = tup3(tup2([Some("hi")], 18), [[Success(1)]], [{ x : 7, y: 15 }] );
    var z2 = tup3(tup2([Some("hi")], 18), [[Success(1)]], [{ x : 7, y: 15 }] );
    
    trace(x1.eq_(x2));
    trace(x2.eq_(x3));
    trace(z1.eq_(z2));


    trace([Some({x : 1, y : 2})].eq_([Some({x : 1, y : 2})]));

    // get a specific instance of Eq by Type and store the type class in a variable
    var myEq = Ht.implicitByType("Eq<Array<Option<Int>>>");

    trace(myEq.eq([Some(1), Some(1)],[Some(1), Some(1)]));
    trace(myEq.eq([Some(1), Some(1)],[Some(1), Some(2)]));


    // make use of type classes in your own functions

    function foo <T>(x: { a : T }, z : T, eq:Eq<T>) {
      Ht.implicit(eq);
      return x.a.eq_(z);
    }

    // and use them with the help of the "_" resolver function

    trace(foo._({ a : 5}, 5));

    trace(foo._({ a : "hey"}, "hey"));

    trace(foo._({ a : ["hey"]}, ["hey"]));

  }
  
}

#end