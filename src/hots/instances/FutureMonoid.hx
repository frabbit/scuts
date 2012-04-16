package hots.instances;


//import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import scuts.core.types.Future;
import scuts.macros.Do;

using scuts.core.extensions.Futures;

class FutureMonoid<X> extends MonoidAbstract<Future<X>>
{
  
  public function new (semi:Semigroup<X>) {
    super(FutureSemigroup.get(semi));
  }
  
 
  override public inline function empty ():Future<X> 
  {
    return Future.dead();
  }
}
