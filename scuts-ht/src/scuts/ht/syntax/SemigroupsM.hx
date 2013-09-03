package scuts.ht.syntax;

import scuts.ht.classes.Semigroup;


#if macro
import haxe.macro.Expr;

private typedef R = scuts.ht.macros.implicits.Resolver;

#end

class SemigroupsM
{
  macro public static function append_ <T>(v1:ExprOf<T>, v2:ExprOf<T>):ExprOf<T> 
  {
    return R.resolve(macro scuts.ht.syntax.Semigroups.append, [v1,v2], 3);
  }
  
}
