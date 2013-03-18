package scuts.ht.syntax;
import scuts.ht.classes.Eq;

import scuts.ht.classes.EqAbstract;

class EqBuilder
{
  public static function create <A>(f:A->A->Bool):Eq<A> return new EqByFun(f);
}



class EqByFun<T> extends EqAbstract<T> 
{
  var f:T->T->Bool;
  
  public function new (f:T->T->Bool) this.f = f;
  
  override inline function eq (a:T, b:T):Bool return f(a,b);
}