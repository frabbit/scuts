package scuts.ht.classes;
import scuts.ht.core.Of;



interface CoPure<F> extends Functor<F>
{
  public function coPure <A>(v:A):Of<F,A>;
}