package hots.classes;

import hots.Of;
import scuts.Scuts;


class PureAbstract<F> implements Pure<F>
{
  /**
   * @see <a href="Pure.html">hots.classes.Pure</a>
   */
  public function pure <A>(v:A):Of<F,A> return Scuts.abstractMethod()

}