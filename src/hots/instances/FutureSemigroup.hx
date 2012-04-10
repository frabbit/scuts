package hots.instances;


//import haxe.macro.Expr;

import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;
import scuts.core.types.Future;
import scuts.macros.Do;

using scuts.core.extensions.FutureExt;

class FutureSemigroup<X> extends SemigroupAbstract<Future<X>>
{
  var semi:Semigroup<X>;
  
  public function new (semi:Semigroup<X>) this.semi = semi
  
  override public function append (a:Future<X>, b:Future<X>):Future<X> 
  {
    return Do.run(
      x1 <= a, 
      x2 <= b, 
      return semi.append(x1,x2)
    );
  }
 
}
