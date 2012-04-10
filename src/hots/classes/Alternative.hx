package hots.classes;
import hots.Of;

/**
 * ...
 * @author 
 */

interface AlternativeArray<F> implements Applicative<F>
{
  /* one or more */
  public function some <A>(v:Of<F, A>):Of<F, Array<A>>;
  /* zero or more */
  public function many <A>(v:Of<F, A>):Of<F, Array<A>>;
  
  public function empty <A>():Of<F, A>;
  
  public function append <A>():Of<F, A>;
  
}