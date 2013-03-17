package ;

import scuts.ht.syntax.Eqs;
import scuts.ht.syntax.EqBuilder;

import scuts.core.Tuples;

import scuts.core.Validations;
import scuts.core.Options;


using scuts.ht.Context;

typedef Point = {
  x:Int,
  y:Int
}

class Equals 
{
  
  
  
  public static function main() 
  {
    function eqPoint (a:Point,b:Point) return a.x.eq_(b.x) && a.y.eq_(b.y);

    Hots.implicit(EqBuilder.create(eqPoint));
    
    var x1 = Tup3.create("hi", 1, { x : 10, y: 15 } );
    var x2 = Tup3.create("hi", 1, { x : 10, y: 15 } );
    var x3 = Tup3.create("hi", 1, { x : 7, y: 15 } );
    
    var z1 = Tup3.create(Tup2.create([Some("hi")], 18), [[Success(1)]], [{ x : 7, y: 15 }] );
    var z2 = Tup3.create(Tup2.create([Some("hi")], 18), [[Success(1)]], [{ x : 7, y: 15 }] );
    
    trace(x1.eq_(x2));
    trace(x2.eq_(x3));
    trace(z1.eq_(z2));

    
    Hots.implicit(Hots.implicitByType("Eq<Array<Option<Point>>>"));


    [Some({x : 1, y : 2})].eq_([Some({x : 1, y : 2})]);

  }
  
}
