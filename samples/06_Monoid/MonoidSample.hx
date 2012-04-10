package ;

import hots.classes.Collection;
import hots.classes.Foldable;
import hots.classes.Monoid;
import hots.instances.IntProductMonoid;
import hots.Of;
import hots.instances.OptionMonoid;
import hots.instances.OptionSemigroup;
import hots.instances.ArrayMonoid;
import hots.instances.ArraySemigroup;
import hots.instances.Tup2Monoid;
import hots.instances.StringMonoid;
import hots.instances.StringSemigroup;
import hots.instances.IntSumMonoid;
import hots.instances.IntSumSemigroup;

import scuts.core.types.Tup2;

using hots.macros.TcContext;
using hots.macros.Box;

import scuts.core.types.Option;

class MonoidSample 
{

  
  
  public static function main () 
  {
    {
      var a = Some([1,2,3]);
      var b = Some([4,5,6]);
      
      var m = a.tc(Monoid);
      
      trace(m.append(a,b));
    }
    {
      var a = Some(7);
      var b = Some(9);
      
      
      var m = a.tc(Monoid);
      
      trace(m.append(a,b));
    }
    
    {
      var a = Some(7);
      var b = Some(9);
      
      var productMonoid = IntProductMonoid.get();
      
      var m = a.tc(Monoid, [productMonoid]);
      
      trace(m.append(a,b));
    }
    
    
    
  }
  
  
}


