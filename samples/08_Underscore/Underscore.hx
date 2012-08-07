package ;

#if macro
import haxe.macro.Expr;
#end


#if !macro extern #end
class Underscore {

  
  @:macro public static function _ (f:ExprOf<Dynamic>, ?args:Array<Expr>):Expr
  {
    return UnderscoreInternal.apply(f, args);
  }
    
}