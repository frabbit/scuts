package hots.classes;
import hots.Of;



interface Pointed<F> implements Functor<F>
{
  public function pure <A>(v:A):Of<F,A>;
}