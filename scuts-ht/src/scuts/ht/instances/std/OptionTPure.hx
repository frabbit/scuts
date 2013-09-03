package scuts.ht.instances.std;
import scuts.ht.classes.Pure;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.classes.Functor;
import scuts.ht.instances.std.OptionTOf;
import scuts.core.Options;






class OptionTPure<M> implements Pure<Of<M,Option<In>>> {
  
  var pureM:Pure<M>;

  public function new (pureM:Pure<M>) 
  {
    this.pureM = pureM;
  }

  /**
   * aka return
   */
  public function pure<A>(x:A):OptionTOf<M,A> {
    return pureM.pure(Options.pure(x));
  }
  

}
