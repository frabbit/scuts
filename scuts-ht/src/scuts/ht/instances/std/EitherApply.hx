package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;



import scuts.core.Eithers;

class EitherApply<L> extends ApplyAbstract<Either<L,_>>
{
  public function new (func) {
  	super(func);
  }

  override public function apply<A,B>(x:Either<L,A>, f:Either<L,A->B>):Either<L,B>
  {
    return Eithers.applyRight(x, f);
  }
}

