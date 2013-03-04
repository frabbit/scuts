package ;

import scuts1.classes.Eq;
import scuts1.syntax.Eqs;
import scuts1.core.Hots;
import scuts.core.Tup2;
import scuts.core.Tup3;

using scuts1.core.Hots;
using scuts1.Identity;
using scuts1.ImplicitInstances;
using scuts1.ImplicitCasts;

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
