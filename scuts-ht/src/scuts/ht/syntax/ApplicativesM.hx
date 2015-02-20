package scuts.ht.syntax;

import scuts.ht.core.Of;

#if macro
import haxe.macro.Expr;
private typedef R = scuts.ht.macros.implicits.Resolver;
#end




class ApplicativesM
{


  macro public static function thenRight_<M,A,B>(x:ExprOf<M<A>>, y:ExprOf<M<B>>):ExprOf<M<B>>
  {
    return R.resolve(macro scuts.ht.syntax.Applicatives.thenRight, [x,y]);
  }


  macro public static function thenLeft_<M,A,B>(x:ExprOf<M<A>>, y:ExprOf<M<B>>):ExprOf<M<A>>
  {
    return R.resolve(macro scuts.ht.syntax.Applicatives.thenLeft, [x,y]);
  }


}







