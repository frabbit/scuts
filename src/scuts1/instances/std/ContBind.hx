package scuts1.instances.std;

import scuts1.classes.Bind;
import scuts1.classes.Functor;
import scuts1.core.In;
import scuts1.instances.std.ContOf;
import scuts.core.Conts;
import scuts.core.Cont;
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



		