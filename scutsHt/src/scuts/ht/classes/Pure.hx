package scuts.ht.classes;
import scuts.ht.core.Of;

private typedef MyOf<F,A> = Of<F,A>;

interface Pure<F>
{
  /**
   * lifts the value v in a context provided by the actual instance.
   * 
   * aka: return
   */
  public function pure <A>(v:A):MyOf<F,A>;
}