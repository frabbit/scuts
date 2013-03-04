package scuts1.syntax;
import scuts1.classes.Foldable;
import scuts1.classes.Monoid;
import scuts1.classes.Ord;
import scuts1.core.Of;


class Foldables
{
  public static function minimum <F,A>(x:Of<F,A>, ord:Ord<A>, fo:Foldable<F>) return fo.foldRight1(x, ord.min);
  
  public static function maximum <F,A>(x:Of<F,A>, ord:Ord<A>, fo:Foldable<F>) return fo.foldRight1(x, ord.max);
  
  public static function fold <F, A> (x:Of<F,A>, mon:Monoid<A>, fo:Foldable<F>):A return fo.fold(x, mon);
  
  public static function foldMap <F,A,B>(x:Of<F,A>, f:A->B, mon:Monoid<B>, fo:Foldable<F> ):B return fo.foldMap(x, f, mon);
 
  public static function foldLeft <F,A,B>(x:Of<F,B>, b:A, f:A->B->A, fo:Foldable<F>):A return fo.foldLeft(x, b, f);
  
  public static function foldRight <F,A,B>(x:Of<F,A>, b:B, f:A->B->B, fo:Foldable<F>):B return fo.foldRight(x, b, f);
  
  public static function foldLeft1 <F,A>(x:Of<F,A>, f:A->A->A, fo:Foldable<F>):A return fo.foldLeft1(x, f);
  
  public static function foldRight1 <F,A>(x:Of<F,A>, f:A->A->A, fo:Foldable<F>):A return fo.foldRight1(x, f);
  
}