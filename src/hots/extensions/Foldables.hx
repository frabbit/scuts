package hots.extensions;
import hots.classes.Foldable;
import hots.classes.Ord;
import hots.Of;


class Foldables
{
  public static function minimum <F,A>(of:Of<F,A>, ord:Ord<A>, fo:Foldable<F>) return fo.foldRight1(of, ord.min)
  
  public static function maximum <F,A>(of:Of<F,A>, ord:Ord<A>, fo:Foldable<F>) return fo.foldRight1(of, ord.max)
  
  public function fold <F, A> (of:Of<F,A>, mon:Monoid<A>, fo:Foldable<F>):A return fo.fold(of, mon)
  
  public function foldMap <F,A,B>(of:Of<F,A>, mon:Monoid<B>, f:A->B, fo:Foldable<F> ):B return fo.foldMap(of, mon, f)
 
  public function foldLeft <F,A,B>(of:Of<F,B>, b:A, f:A->B->A, fo:Foldable<F>):A return fo.foldLeft(of, b, f)
  
  public function foldRight <F,A,B>(of:Of<F,A>, b:B, f:A->B->B, fo:Foldable<F>):B return fo.foldRight(of, b, f)
  
  public function foldLeft1 <F,A>(of:Of<F,A>, f:A->A->A, fo:Foldable<F>):A return fo.foldLeft(of, f)
  
  public function foldRight1 <F,A>(of:Of<F,A>, f:A->A->A, fo:Foldable<F>):A return fo.foldLeft(of, f)
  
}