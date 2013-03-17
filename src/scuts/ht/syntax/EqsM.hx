package scuts.ht.syntax;


#if macro
import haxe.macro.Expr;
import scuts.ht.macros.implicits.Resolver;
#end

class EqsM
{

  #if display
  public static function eq_ <T> (v1:T, v2:T):Bool return null;
  #else
  macro public static function eq_ <T> (v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<Bool> 
  	return Resolver.resolve(macro scuts.ht.syntax.Eqs.eq, [v1, v2]);
  #end

}


