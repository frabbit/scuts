
package scuts.ht.syntax;

#if macro
import haxe.macro.Expr;
#else
import scuts.ht.core.Of;
#end

class MonadsM {

  #if display

  public static function sequence_ <M,B>(arr:Array<Of<M, B>>):Of<M,Array<B>> return null;

  #else

  macro public static function sequence_ <M,B>(arr:ExprOf<Array<Of<M, B>>>):ExprOf<Of<M,Array<B>>>
    return scuts.ht.macros.implicits.Resolver.resolve(macro scuts.ht.syntax.Monads.sequence, [arr]);

  #end

}