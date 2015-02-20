package scuts.ht.syntax;


#if macro
import haxe.macro.Expr;
#end

class MonadsM {



  macro public static function sequence_ <M,B>(arr:ExprOf<Array<M<B>>>):ExprOf<M<Array<B>>>
    return scuts.ht.macros.implicits.Resolver.resolve(macro scuts.ht.syntax.Monads.sequence, [arr]);


}