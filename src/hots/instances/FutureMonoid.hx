package hots.instances;


//import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import scuts.core.types.Future;
import scuts.macros.Do;

using scuts.core.extensions.FutureExt;

class FutureMonoid<X> extends MonoidAbstract<Future<X>>
{
  var monoid:Monoid<X>;
  
  public function new (monoid:Monoid<X>) this.monoid = monoid
  
  override public function append (a:Future<X>, b:Future<X>):Future<X> 
  {
    return Do.run(
      x1 <= a, 
      x2 <= b, 
      return monoid.append(x1,x2)
    );
  }
  override public inline function empty ():Future<X> 
  {
    return Future.dead();
  }
}
