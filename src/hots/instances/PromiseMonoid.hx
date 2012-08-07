package hots.instances;


//import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import scuts.core.types.Promise;
import scuts.macros.Do;

using scuts.core.extensions.Futures;

class PromiseMonoid<X> extends MonoidAbstract<Promise<X>>
{
  public function new (semi:Semigroup<X>) 
  {
    super(PromiseSemigroup.get(semi));
  }

  override public inline function empty ():Promise<X> 
  {
    return new Promise().cancel();
  }
}
