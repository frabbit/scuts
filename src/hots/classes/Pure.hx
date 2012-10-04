package hots.classes;
import hots.Of;

interface Pure<F>
{
  /**
   * lifts the value v in a context provided by the actual instance.
   * 
   * aka: return
   */
  public function pure <A>(v:A):Of<F,A>;
}