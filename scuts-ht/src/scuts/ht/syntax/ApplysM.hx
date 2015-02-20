package scuts.ht.syntax;


#if macro
import haxe.macro.Expr;
private typedef R = scuts.ht.macros.implicits.Resolver;
#end




class ApplysM
{
  macro public static function apply_<M,A,B>(x:ExprOf<M<A>>, f:ExprOf<M<A->B>>):ExprOf<M<B>>
  {
    return R.resolve(macro scuts.ht.syntax.Applys.apply, [x,f]);
  }

  macro public static function apply2_ <M,A,B,C>(fa:ExprOf<M<A>>, fb:ExprOf<M<B>>, f:ExprOf<A->B->C>):ExprOf<M<C>>
  {
    return R.resolve(macro scuts.ht.syntax.Applys.apply2, [fa,fb, f]);
  }

  macro public static function apply3_ <M,A,B,C,D>(fa:ExprOf<M<A>>, fb:ExprOf<M<B>>, fc:ExprOf<M<C>>, f:ExprOf<A->B->C->D>):ExprOf<M<D>>
  {
    return R.resolve(macro scuts.ht.syntax.Applys.apply3, [fa,fb, fc, f]);
  }

  macro public static function lift2_<F,A, B, C>(f: ExprOf<A -> B -> C>, applicative:String): ExprOf<F<A> -> F<B> -> F<C>>
  {
    var app = R.resolveImplicitObjByType("Apply<" + applicative + ">");
    return R.resolve(macro scuts.ht.syntax.Applys.lift2, [f, app]);
  }

  macro public static function lift3_<F,A, B, C,D>(f: ExprOf<A -> B -> C ->D>, applicative:String): ExprOf<F<A> -> F<B> -> F<C> -> F<D>>
  {
    var app = R.resolveImplicitObjByType("Apply<" + applicative + ">");
    return R.resolve(macro scuts.ht.syntax.Applys.lift2, [f, app]);
  }




  macro public static function ap_<M,A,B>(f:ExprOf<M<A->B>>):ExprOf<M<A>->M<B>>
  {
    return R.resolve(macro scuts.ht.syntax.Applys.ap, [f]);
  }
}







