package scuts1.instances.std;
import scuts1.classes.Applicative;


import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.ArrayTOf;
import scuts.core.Arrays;
import scuts1.classes.Functor;





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
