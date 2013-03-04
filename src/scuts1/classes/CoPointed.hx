package scuts1.classes;
import scuts1.core.Of;



interface CoPointed<F> extends Functor<F>
{
  public function copure <A>(v:A):Of<F,A>;
}