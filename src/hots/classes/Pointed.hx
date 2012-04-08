package hots.classes;
import hots.Of;
import hots.TC;


interface Pointed<F> implements Functor<F>, implements TC
{
  public function pure <A>(v:A):Of<F,A>;
}