package hots.extensions;
import hots.classes.Foldable;
import hots.classes.Ord;
import hots.Of;


/**
 * ...
 * @author 
 */

class FoldableExt 
{

  public static function minimum <M,A>(f:Foldable<M>, val:Of<M,A>, ord:Ord<A>) {
    return f.foldRight1(ord.min, val);
  }
  
  public static function maximum <M,A>(f:Foldable<M>, val:Of<M,A>, ord:Ord<A>) {
    return f.foldRight1(ord.max, val);
  }
  
}