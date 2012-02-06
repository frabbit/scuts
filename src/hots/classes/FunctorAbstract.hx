package hots.classes;

import hots.Of;
import scuts.Scuts;


@:tcAbstract class FunctorAbstract<F> implements Functor<F>
{
  /**
   * @inheritDoc
   */
  public function map<A,B>(f:A->B, val:Of<F,A>):Of<F,B> return Scuts.abstractMethod()
}

















