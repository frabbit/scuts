package hots.classes;
import hots.Of;



interface CoPointed<F> implements Functor<F>
{
  public function copure <A>(v:A):Of<F,A>;
}