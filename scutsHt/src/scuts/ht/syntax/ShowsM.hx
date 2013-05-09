package scuts.ht.syntax;

//import scuts.ht.classes.Show;


//import scuts.ht.macros.implicits.DisplayResolver;
#if macro
import haxe.macro.Expr;
import scuts.ht.macros.implicits.Resolver;
//import scuts.ht.macros.implicits.DisplayResolver;
#end

class ShowsM
{
  	macro public static function show_ <T> (x:ExprOf<T>):ExprOf<String>
	{
		return Resolver.resolve(macro scuts.ht.syntax.Shows.show, [x], 2);
		//return macro "";
	}
}
