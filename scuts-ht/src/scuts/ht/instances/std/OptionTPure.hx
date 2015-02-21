package scuts.ht.instances.std;
import scuts.ht.classes.Pure;
import scuts.ht.classes.Functor;
using scuts.ht.instances.std.OptionT;
import scuts.core.Options;






class OptionTPure<M> implements Pure<OptionT<M,_>> {

  var pureM:Pure<M>;

  public function new (pureM:Pure<M>)
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  public function pure<A>(x:A):OptionT<M,A> {
    return pureM.pure(Options.pure(x)).optionT();
  }


}
