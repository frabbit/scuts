package scuts.macros;

#if macro
import haxe.macro.Expr.ExprRequire;
import haxe.macro.Expr;
import scuts.mcore.Parse;
#end
class Lazy 
{

  @:macro public static function expr(expr:ExprRequire<Dynamic>):Expr 
  {
    var op = "scuts.core.types.Option";
    var ops = "scuts.core.extensions.OptionExt";
    
    return Parse.parse("{var r = null; var isSet = false; function () { if (!isSet) {r = $0; isSet = true;} return r; }}", [expr], expr.pos);
  }
  
}