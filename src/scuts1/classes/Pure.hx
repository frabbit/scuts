package scuts1.classes;
import scuts1.core.Of;

interface Pure<F>
{
  /**
   * lifts the value v in a context provided by the actual instance.
   * 
   * aka: return
   */
  public function pure <A>(v:A):Of<F,A>;
}