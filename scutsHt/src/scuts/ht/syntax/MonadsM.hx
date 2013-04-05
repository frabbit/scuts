
package scuts.ht.syntax;

import scuts.ht.core.Of;

#if macro
import haxe.macro.Expr;
#end

class MonadsM {

  #if xdisplay

  public static function sequence_ <M,B>(arr:Array<Of<M, B>>):Of<M,Array<B>> return null;

  #else

  macro public static function sequence_ <M,B>(arr:ExprOf<Array<Of<M, B>>>):ExprOf<Of<M,Array<B>>>
    return scuts.ht.macros.implicits.Resolver.resolve(macro scuts.ht.syntax.Monads.sequence, [arr]);

  #end

}