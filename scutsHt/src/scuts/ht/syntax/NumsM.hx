package scuts.ht.syntax;

import scuts.ht.classes.Num;

#if macro
import haxe.macro.Expr.ExprOf;
private typedef R = scuts.ht.macros.implicits.Resolver;
#end

class NumsM
{
  macro public static inline function plus_   <A>(a:ExprOf<A>, b:ExprOf<A>):ExprOf<A> 
  {
  	return R.resolve(macro @:pos(a.pos) scuts.ht.syntax.Nums.plus, [a,b], 3);
  }

  macro public static inline function mul_    <A>(a:ExprOf<A>, b:ExprOf<A>):ExprOf<A> 
  {
  	return R.resolve(macro @:pos(a.pos) scuts.ht.syntax.Nums.mul, [a,b], 3);
  }

  macro public static inline function minus_  <A>(a:ExprOf<A>, b:ExprOf<A>):ExprOf<A> 
  {
  	return R.resolve(macro @:pos(a.pos) scuts.ht.syntax.Nums.minus, [a,b], 3);
  }

  macro public static inline function negate_ <A>(a:ExprOf<A>):ExprOf<A>      
  {
  	return R.resolve(macro @:pos(a.pos) scuts.ht.syntax.Nums.negate, [a], 2);
  }

  macro public static inline function abs_    <A>(a:ExprOf<A>):ExprOf<A>      
  {
  	return R.resolve(macro @:pos(a.pos) scuts.ht.syntax.Nums.abs, [a], 2);
  }

  macro public static inline function signum_ <A>(a:ExprOf<A>):ExprOf<A>      
  {
  	return R.resolve(macro @:pos(a.pos) scuts.ht.syntax.Nums.signum, [a], 2);
  }

  macro public static inline function fromInt_ <A>(a:ExprOf<Int>, numAsTypeString:String):ExprOf<A> 
  {
  	var num = R.resolveImplicitObjByType("scuts.ht.classes.Num<" + numAsTypeString + ">");
  	return R.resolve(macro @:pos(a.pos) scuts.ht.syntax.Nums.fromInt, [a, num], 2);
  }

}
