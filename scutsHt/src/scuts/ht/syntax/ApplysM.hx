package scuts.ht.syntax;

import scuts.ht.core.Of;

#if macro
import haxe.macro.Expr;
typedef R = scuts.ht.macros.implicits.Resolver;
#end


#if display

class ApplysM
{
  
  public static inline function apply_<M,A,B>(x:Of<M,A>, f:Of<M,A->B>):Of<M,B> {}

  public static inline function apply2_ <M,A,B,C>(fa:Of<M,A>, fb:Of<M,B>, f:A->B->C):Of<M,C> {}

  public static inline function apply3_ <M,A,B,C,D>(fa:Of<M,A>, fb:Of<M,B>, fc:Of<M,C>, f:A->B->C->D):Of<M,D> {}
  
  public static inline function lift2_<F,A, B, C>(f: A -> B -> C, apply:String): Of<F,A> -> Of<F,B> -> Of<F,C> {}

  public static inline function lift3_<F,A, B, C,D>(f: A -> B -> C ->D, apply:String): Of<F,A> -> Of<F,B> -> Of<F,C> -> Of<F,D> {}

  public static function ap_<M,A,B>(f:Of<M, A->B>):Of<M, A>->Of<M,B> {}
  
}

#else

class ApplysM 
{
  macro public static function apply_<M,A,B>(x:ExprOf<Of<M,A>>, f:ExprOf<Of<M,A->B>>):ExprOf<Of<M,B>>
  {
    return R.resolve(macro scuts.ht.syntax.Applys.apply, [x,f]);
  }

  macro public static function apply2_ <M,A,B,C>(fa:ExprOf<Of<M,A>>, fb:ExprOf<Of<M,B>>, f:ExprOf<A->B->C>):ExprOf<Of<M,C>> 
  {
    return R.resolve(macro scuts.ht.syntax.Applys.apply2, [fa,fb, f]);
  }

  macro public static function apply3_ <M,A,B,C,D>(fa:ExprOf<Of<M,A>>, fb:ExprOf<Of<M,B>>, fc:ExprOf<Of<M,C>>, f:ExprOf<A->B->C->D>):ExprOf<Of<M,D>> 
  {
    return R.resolve(macro scuts.ht.syntax.Applys.apply3, [fa,fb, fc, f]); 
  }
  
  macro public static function lift2_<F,A, B, C>(f: ExprOf<A -> B -> C>, applicative:String): ExprOf<Of<F,A> -> Of<F,B> -> Of<F,C>> 
  {
    var app = R.resolveImplicitObjByType("Apply<" + applicative + ">");
    return R.resolve(macro scuts.ht.syntax.Applys.lift2, [f, app]); 
  }

  macro public static function lift3_<F,A, B, C,D>(f: ExprOf<A -> B -> C ->D>, applicative:String): ExprOf<Of<F,A> -> Of<F,B> -> Of<F,C> -> Of<F,D>> 
  {
    var app = R.resolveImplicitObjByType("Apply<" + applicative + ">");
    return R.resolve(macro scuts.ht.syntax.Applys.lift2, [f, app]); 
  }

  
  
  
  macro public static function ap_<M,A,B>(f:ExprOf<Of<M, A->B>>):ExprOf<Of<M, A>->Of<M,B>> 
  {
    return R.resolve(macro scuts.ht.syntax.Applys.ap, [f]); 
  }
}

#end





