package hots.instances;
import hots.classes.Applicative;


import hots.classes.Pure;
import hots.In;
import hots.Of;
import hots.of.ArrayTOf;
import scuts.core.extensions.Arrays;
import hots.classes.Functor;


using hots.ImplicitCasts;
using hots.Identity;

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
    return pureM.pure([x]).intoT();
  }
  

}
