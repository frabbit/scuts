package scuts.ht.syntax;
import scuts.ht.classes.Category;
import scuts.ht.core.OfOf;

#if macro
import haxe.macro.Expr;
typedef R = scuts.ht.macros.implicits.Resolver;
#end

class CategorysM
{
  macro public static function id_ <A, Cat>(a:ExprOf<A>, catName:ExprOf<String>):ExprOf<OfOf<Cat, A, A>> 
  {
  	var cat = R.resolveImplicitObjByType("scuts.ht.classes.Category<" + catName + ">");
  	return R.resolve(macro @:pos(a.pos) scuts.ht.syntax.Categorys.id, [a, cat], 2);
  }
  
  macro public static function next_ <A,B,C,Cat>(f:ExprOf<OfOf<Cat, A, B>>, g:ExprOf<OfOf<Cat, B, C>>):ExprOf<OfOf<Cat,A, C>>
  {
  	return R.resolve(macro @:pos(f.pos) scuts.ht.syntax.Categorys.next, [f,g], 3);
  }
  
  macro public static function dot_ <A,B,C, Cat>(g:ExprOf<OfOf<Cat, B, C>>, f:ExprOf<OfOf<Cat, A, B>>):ExprOf<OfOf<Cat, A, C>> 
  {
  	return R.resolve(macro @:pos(g.pos) scuts.ht.syntax.Categorys.dot, [g,f], 3);
  }
  
  macro public static function back_ <A,B,C, Cat>(g:ExprOf<OfOf<Cat, B, C>>, f:ExprOf<OfOf<Cat, A, B>>):ExprOf<OfOf<Cat,A, C>> 
  {
  	return R.resolve(macro @:pos(g.pos) scuts.ht.syntax.Categorys.back, [g,f], 3);
  }
  
}