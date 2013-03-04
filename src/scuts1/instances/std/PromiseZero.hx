package scuts1.instances.std;


//import haxe.macro.Expr;

import scuts1.classes.Semigroup;
import scuts1.classes.Zero;
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
