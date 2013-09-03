package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.classes.Functor;
import scuts.ht.core.In;
import scuts.ht.instances.std.ContOf;
import scuts.core.Conts;

using scuts.core.Functions;

class ContBind<R> implements Bind<Cont<In, R>>
{
  public function new () {}
  
  //public function flatMap<A,B>(x:Of<M,A>, f:A->Of<M,B>):Of<M,B>;

  public function flatMap<A,B>(x:ContOf<A,R>, f:A->ContOf<B,R>):ContOf<B,R> 
  {
  	return null;
    //return Conts.flatMap(x, f);
  }
}



		