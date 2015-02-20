package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.classes.Functor;
import scuts.core.Conts;

using scuts.core.Functions;

class ContBind<R> implements Bind<Cont<R, In>>
{
  public function new () {}

  //public function flatMap<A,B>(x:Of<M,A>, f:A->Of<M,B>):Of<M,B>;

  public function flatMap<A,B>(x:Cont<R,A>, f:A->Cont<R,B>):Cont<R,B>
  {
  	return Conts.flatMap(x, f);
  }
}



