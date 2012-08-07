package hots.instances;

import hots.classes.FunctorAbstract;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.In;
import hots.instances.Function1Semigroup;
import hots.Of;

using hots.box.FunctionBox;

class Function1Functor<X> extends FunctorAbstract<X->In>
{
  public function new () {}
  
  override public function map<A,B>(of:Of<X->In, A>, f:A->B):Of<X->In, B> 
  {
    return (function (x:X) return f(of.unbox()(x))).box();
  }
}
