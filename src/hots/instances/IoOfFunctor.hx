package hots.instances;
import hots.classes.FunctorAbstract;
import scuts.core.extensions.Ios;
import scuts.core.types.Io;

using scuts.core.extensions.Ios;
using hots.box.IoBox;

class IoOfFunctor extends FunctorAbstract<Io<In>>
{
  public function new () {}
  
  override public function map<A,B>(of:IoOf<A>, f:A->B):IoOf<B> 
  {
    return Ios.map(of.unbox(), f).box();
  }
}


