package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.instances.std.EitherOf;



import scuts.core.Eithers;

class EitherApply<L> extends ApplyAbstract<Either<L,In>> 
{
  public function new (func) {
  	super(func);
  }
  
  override public function apply<A,B>(x:EitherOf<L,A>, f:EitherOf<L,A->B>):EitherOf<L,B> 
  {
    return Eithers.applyRight(x, f);
  }
}

