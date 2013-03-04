package scuts1.syntax;
import scuts1.core.Of;


import scuts1.classes.Functor;

#if macro
import haxe.macro.Expr;
import scuts1.macros.implicits.Resolver;
#end

class Functors 
{
  
  public static inline function map <F,A,B> (x:Of<F, A>, f:A->B, functor:Functor<F>):Of<F,B> 
  	return functor.map(x, f);
  
  

  #if display
  public static function map_ <F,A,B> (x:Of<F, A>, f:A->B):Of<F,B> return null;
  #else
  macro public static function map_ <F,A,B> (x:ExprOf<Of<F, A>>, f:ExprOf<A->B>):ExprOf<Of<F,B>> 
  	return Resolver.resolve(macro scuts1.syntax.Functors.map, [x, f]);
  #end
}