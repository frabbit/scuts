
package scuts.ht.syntax;

import scuts.ht.core.Of;

#if macro
import haxe.macro.Expr;
#end

class MonadsM {



  macro public static function sequence_ <M,B>(arr:ExprOf<Array<Of<M, B>>>):ExprOf<Of<M,Array<B>>>
    return scuts.ht.macros.implicits.Resolver.resolve(macro scuts.ht.syntax.Monads.sequence, [arr]);


}