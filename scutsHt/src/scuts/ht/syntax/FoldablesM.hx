package scuts.ht.syntax;
import scuts.ht.classes.Foldable;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Ord;
import scuts.ht.core.Of;
#if macro
import haxe.macro.Expr;
private typedef R = scuts.ht.macros.implicits.Resolver;
#end


class FoldablesM
{
  macro public static function minimum <F,A>(x:ExprOf<Of<F,A>>):ExprOf<A> 
  {
  	return R.resolve(macro scuts.ht.syntax.Foldables.minimum, [x], 3);
  }
  
  macro public static function maximum <F,A>(x:ExprOf<Of<F,A>>):ExprOf<A> 
  {
  	return R.resolve(macro scuts.ht.syntax.Foldables.maximum, [x], 3);
  }
  
  macro public static function fold <F, A> (x:ExprOf<Of<F,A>>):ExprOf<A> 
  {
  	return R.resolve(macro scuts.ht.syntax.Foldables.fold, [x], 3);
  }
  
  macro public static function foldMap <F,A,B>(x:ExprOf<Of<F,A>>, f:ExprOf<A->B>):ExprOf<B> 
  {
  	return R.resolve(macro scuts.ht.syntax.Foldables.foldMap, [x,f], 4);
  }
 
  macro public static function foldLeft <F,A,B>(x:ExprOf<Of<F,B>>, b:ExprOf<A>, f:ExprOf<A->B->A>):ExprOf<A> 
  {
  	return R.resolve(macro scuts.ht.syntax.Foldables.foldLeft, [x,b,f], 4);
  }
  
  macro public static function foldRight <F,A,B>(x:ExprOf<Of<F,A>>, b:ExprOf<B>, f:ExprOf<A->B->B>):ExprOf<B> 
  {
  	return R.resolve(macro scuts.ht.syntax.Foldables.foldRight, [x,b,f], 4);
  }
  
  macro public static function foldLeft1 <F,A>(x:ExprOf<Of<F,A>>, f:ExprOf<A->A->A>):ExprOf<A> 
  {
  	return R.resolve(macro scuts.ht.syntax.Foldables.foldLeft1, [x,f], 3);
  }
  
  macro public static function foldRight1 <F,A>(x:ExprOf<Of<F,A>>, f:ExprOf<A->A->A>):ExprOf<A> 
  {
  	return R.resolve(macro scuts.ht.syntax.Foldables.foldRight1, [x,f], 3);
  }
  
}