package scuts.ht.syntax;
import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.core.Ordering;

#if macro
import haxe.macro.Expr.ExprOf;
private typedef R = scuts.ht.macros.implicits.Resolver;
#end


class OrdsM
{

  
  macro public static inline function compare_<T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<Ordering>
  {
  	return R.resolve(macro @:pos(v1.pos) scuts.ht.syntax.Ords.compare, [v1,v2], 3);
  }

  macro public static inline function compareInt_<T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<Int> 
  {
  	return R.resolve(macro @:pos(v1.pos) scuts.ht.syntax.Ords.compareInt, [v1,v2], 3);
  }
    
  macro public static inline function greater_<T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<Bool> 
  {
  	return R.resolve(macro @:pos(v1.pos) scuts.ht.syntax.Ords.greater, [v1,v2], 3);
  }
  
  macro public static inline function less_<T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<Bool> 
  {
  	return R.resolve(macro @:pos(v1.pos) scuts.ht.syntax.Ords.less, [v1,v2], 3);
  }
  
  macro public static inline function greaterOrEq_<T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<Bool> 
  {
  	return R.resolve(macro @:pos(v1.pos) scuts.ht.syntax.Ords.greaterOrEq, [v1,v2], 3);
  }
  
  macro public static inline function lessOrEq_<T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<Bool> 
  {
  	return R.resolve(macro @:pos(v1.pos) scuts.ht.syntax.Ords.lessOrEq, [v1,v2], 3);
  }
  
  macro public static inline function max_<T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<T> 
  {
  	return R.resolve(macro @:pos(v1.pos) scuts.ht.syntax.Ords.max, [v1,v2], 3);
  }
  
  macro public static inline function min_<T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<T> 
  {
  	return R.resolve(macro @:pos(v1.pos) scuts.ht.syntax.Ords.min, [v1,v2], 3);
  }
  
}
