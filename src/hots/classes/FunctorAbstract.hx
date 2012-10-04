package hots.classes;

import hots.Of;
import scuts.Scuts;


class FunctorAbstract<F> implements Functor<F>
{
  /**
   * @see <a href="Functor.html">hots.classes.Functor</a>
   */
  public function map<A,B>(x:Of<F,A>, f:A->B):Of<F,B> return Scuts.abstractMethod()
}

