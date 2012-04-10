package hots.classes;
import hots.Of;
import hots.classes.Monoid;
import hots.TC;


// minimal implementation foldRight or foldMap
interface Foldable<F> implements TC 
{
  public function fold <A>(of:Of<F,A>, mon:Monoid<A>):A;
  
  public function foldMap <A,B>(of:Of<F,A>, mon:Monoid<B>, f:A->B ):B;
 
  public function foldLeft <A,B>(of:Of<F,B>, b:A, f:A->B->A):A;
  
  public function foldRight <A,B>(of:Of<F,A>, b:B, f:A->B->B):B;
  
  public function foldLeft1 <A>(of:Of<F,A>, f:A->A->A):A;
  
  public function foldRight1 <A>(of:Of<F,A>, f:A->A->A):A;
  
  
}