package hots.classes;

/**
 * ...
 * @author 
 */

interface Pointed<F> implements Functor<F>
{
  public function pure <A>(v:A):Of<F,A>;
}