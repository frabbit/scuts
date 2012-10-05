package hots.instances;


//import haxe.macro.Expr;

import hots.classes.Semigroup;
import hots.classes.Zero;
import scuts.core.extensions.Promises;
import scuts.core.types.Promise;

class PromiseZero<X> implements Zero<Promise<X>>
{
  public function new () {}

  public inline function zero ():Promise<X> 
  {
    return Promises.cancelled();
  }
}
