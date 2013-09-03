package scuts.ht.instances.std;
import scuts.ht.classes.Applicative;


import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.ArrayTOf;
import scuts.core.Arrays;
import scuts.ht.classes.Functor;





class ArrayTPure<M> implements Pure<Of<M,Array<In>>> 
{
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) 
  {
    this.pureM = pureM;
  }

  /**
   * aka return, pure
   */
  public function pure<A>(x:A):ArrayTOf<M,A> 
  {
    return pureM.pure([x]);
  }
  

}
