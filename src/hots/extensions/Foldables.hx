package hots.extensions;
import hots.classes.Foldable;
import hots.classes.Ord;
import hots.Of;


/**
 * ...
 * @author 
 */

class Foldables
{

  public static function minimum <M,A>(f:Foldable<M>, of:Of<M,A>, ord:Ord<A>) {
    return f.foldRight1(of, ord.min);
  }
  
  public static function maximum <M,A>(f:Foldable<M>, of:Of<M,A>, ord:Ord<A>) {
    return f.foldRight1(of, ord.max);
  }
  
}