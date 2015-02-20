package scuts.ht.instances.std;
import scuts.ht.classes.Applicative;


import scuts.ht.classes.Pure;

using scuts.ht.instances.std.ArrayT;
import scuts.core.Arrays;
import scuts.ht.classes.Functor;


class ArrayTPure<M> implements Pure<ArrayT<M,In>>
{
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>)
  {
    this.pureM = pureM;
  }

  /**
   * aka return, pure
   */
  public function pure<A>(x:A):ArrayT<M,A>
  {
    return pureM.pure([x]).arrayT();
  }


}
