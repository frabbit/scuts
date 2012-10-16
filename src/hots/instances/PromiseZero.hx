package hots.instances;


//import haxe.macro.Expr;

import hots.classes.Semigroup;
import hots.classes.Zero;
import scuts.core.Promises;
import scuts.core.Promise;

class PromiseZero<X> implements Zero<Promise<X>>
{
  public function new () {}

  public inline function zero ():Promise<X> 
  {
    return Promises.cancelled();
  }
}
