package scuts1.classes;
import scuts1.core.Of;



interface AlternativeArray<F> extends Applicative<F>
{
  /* one or more */
  public function some <A>(v:Of<F, A>):Of<F, Array<A>>;
  /* zero or more */
  public function many <A>(v:Of<F, A>):Of<F, Array<A>>;
  
  public function empty <A>():Of<F, A>;
  
  public function append <A>():Of<F, A>;
  
}