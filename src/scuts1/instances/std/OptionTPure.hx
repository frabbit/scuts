package scuts1.instances.std;
import scuts1.classes.Pure;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.classes.Functor;
import scuts1.instances.std.OptionTOf;
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
