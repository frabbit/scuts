package hots.classes;
import hots.Of;
import hots.TC;


interface CoPointed<F> implements Functor<F>, implements TC
{
  public function copure <A>(v:A):Of<F,A>;
}