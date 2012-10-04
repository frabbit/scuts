package hots.instances;


//import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;

class PromiseMonoid<X> extends MonoidAbstract<Promise<X>>
{
  public function new (semi:PromiseSemigroup<X>) 
  {
    super(semi);
  }

  override public inline function empty ():Promise<X> 
  {
    return Promises.cancelled();
  }
}
