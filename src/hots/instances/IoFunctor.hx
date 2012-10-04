package hots.instances;
import hots.classes.FunctorAbstract;
import hots.of.IoOf;
import scuts.core.extensions.Ios;
import scuts.core.types.Io;

using scuts.core.extensions.Ios;
using hots.box.IoBox;

class IoFunctor extends FunctorAbstract<Io<In>>
{
  public function new () {}
  
  override public function map<A,B>(x:IoOf<A>, f:A->B):IoOf<B> 
  {
    return Ios.map(x, f);
  }
}


