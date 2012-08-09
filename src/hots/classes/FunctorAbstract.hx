package hots.classes;

import hots.Of;
import scuts.Scuts;


class FunctorAbstract<F> implements Functor<F>
{
  /**
   * @inheritDoc
   */
  public function map<A,B>(val:Of<F,A>, f:A->B):Of<F,B> return Scuts.abstractMethod()
}

















