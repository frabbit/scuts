package scuts.ht.instances.std;


//import haxe.macro.Expr;

import scuts.ht.classes.Semigroup;
import scuts.ht.classes.Zero;
import scuts.core.Promises;


class PromiseZero<X> implements Zero<PromiseD<X>>
{
  public function new () {}

  public inline function zero ():PromiseD<X> 
  {
    return Promises.cancelled("error");
  }
}
