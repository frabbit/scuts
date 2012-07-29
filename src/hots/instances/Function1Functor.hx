package hots.instances;

import hots.classes.FunctorAbstract;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.In;
import hots.instances.Function1Semigroup;
import hots.macros.Box;
import hots.Of;


class Function1Functor<X> extends FunctorAbstract<X->In>
{
  public function new () {}
  
  override public function map<A,B>(of:Of<X->In, A>, f:A->B):Of<X->In, B> {
    return Box.box(function (x:X) return f(Box.unbox(of)(x)));
  }
}
