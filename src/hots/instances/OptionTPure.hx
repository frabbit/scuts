package hots.instances;
import hots.classes.Pure;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import hots.of.OptionTOf;
import scuts.core.Options;
import scuts.core.Option;


using hots.box.OptionBox;



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
