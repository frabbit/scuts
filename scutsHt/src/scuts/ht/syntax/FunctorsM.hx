package scuts.ht.syntax;

import scuts.ht.core.Of;
#if macro
import haxe.macro.Expr;
import scuts.ht.macros.implicits.Resolver;
#end

class FunctorsM 
{

  #if xdisplay
  public static function map_ <F,A,B> (x:Of<F, A>, f:A->B):Of<F,B> return null;
  #else
  macro public static function map_ <F,A,B> (x:ExprOf<Of<F, A>>, f:ExprOf<A->B>):ExprOf<Of<F,B>> 
  	return Resolver.resolve(macro scuts.ht.syntax.Functors.map, [x, f]);
  #end
}