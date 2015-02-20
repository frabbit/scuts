package scuts.ht.syntax;


import scuts.core.Tuples;

#if macro
import haxe.macro.Expr;
private typedef R = scuts.ht.macros.implicits.Resolver;
#end

class ArrowsM
{

  macro public static function arr_<A,B, AR>(f:ExprOf<A->B>):ExprOf<AR<A, B>>
  {
  	return R.resolve(macro scuts.ht.syntax.Arrows.arr, [f], 2);
  }

  macro public static function split_ <B,B1, C,C1,D, AR>(f:ExprOf<AR<B, C>>, g:ExprOf<AR<B1, C1>>):ExprOf<AR<Tup2<B,B1>, Tup2<C,C1>>>
  {
  	return R.resolve(macro scuts.ht.syntax.Arrows.split, [f,g], 3);
  }

  macro public static function first_ <B,C,D, AR>(f:ExprOf<AR<B,C>>):ExprOf<AR<Tup2<B,D>, Tup2<C,D>>>
  {
  	return R.resolve(macro scuts.ht.syntax.Arrows.first, [f], 2);
  }

  macro public static function second_ <B,C,D, AR>(f:ExprOf<AR<B, C>>):ExprOf<AR<Tup2<D,B>, Tup2<D,C>>>
  {
  	return R.resolve(macro scuts.ht.syntax.Arrows.second, [f], 2);
  }

  macro public static function fanout_ <B,C, C1, AR>(f:ExprOf<AR<B, C>>, g:ExprOf<AR<B, C1>>):ExprOf<AR<B, Tup2<C,C1>>>
  {
  	return R.resolve(macro scuts.ht.syntax.Arrows.fanout, [f,g], 3);
  }



}