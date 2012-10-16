package ;

import hots.classes.Eq;
import hots.extensions.Eqs;
import hots.Hots;
import scuts.core.Tup2;
import scuts.core.Tup3;

using hots.Hots;
using hots.Identity;
using hots.ImplicitInstances;
using hots.ImplicitCasts;

typedef Point = {
  x:Int,
  y:Int
}

class Equals 
{
  
  
  
  public static function main() 
  {
    function eqPoint (a:Point,b:Point) return a.x == b.x && a.y == b.y;

    Hots.implicit(Eqs.create(eqPoint));
    
    var x1 = Tup3.create("hi", 1, { x : 10, y: 15 } );
    var x2 = Tup3.create("hi", 1, { x : 10, y: 15 } );
    
    trace(x1.eq(x2));

  }
  
}
