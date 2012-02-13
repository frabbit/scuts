package hots.classes;
import hots.Of;
import hots.classes.Monoid;
import hots.TC;


// minimal implementation foldRight or foldMap
interface Foldable<F> implements TC 
{
  public function fold <A>(mon:Monoid<A>, val:Of<F,A>):A;
  
  public function foldMap <A,B>(f:A->B, mon:Monoid<B>, val:Of<F,A>):B;
 
  public function foldLeft <A,B>(f:A->B->A, b:A, val:Of<F,B>):A;
  
  public function foldRight <A,B>(f:A->B->B, b:B, val:Of<F,A>):B;
  
  public function foldLeft1 <A>(f:A->A->A, val:Of<F,A>):A;
  
  public function foldRight1 <A>(f:A->A->A, val:Of<F,A>):A;
  
  
}