package hots;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

#end

/**
 * ...
 * @author 
 */

class Gen 
{
  @:macro public static function genCastBox (type:Expr, boxClass:Expr):Type
  {
    
    return hots.macros.casts.Gen.box(type, boxClass, "implicitUpcast", "implicitDowncast", "box", "unbox");
  }
  
  @:macro public static function genCastBoxT (type:Expr, boxClass:Expr):Type
  {
    return hots.macros.casts.Gen.box(type, boxClass, "implicitUpcastT", "implicitDowncastT", "boxT", "unboxT");
  }
  
    @:macro public static function genCastBoxFT (type:Expr, boxClass:Expr):Type
  {
    return hots.macros.casts.Gen.box(type, boxClass, "implicitUpcastT", "implicitDowncastT", "boxFT", "unboxFT");
  }
  
  @:macro public static function genCastBox0 (type:Expr, boxClass:Expr):Type
  {
    return hots.macros.casts.Gen.box(type, boxClass, "implicitUpcast", "implicitDowncast", "box0", "unbox0");
  }
  
  @:macro public static function genCastBoxF (type:Expr, boxClass:Expr):Type
  {
    return hots.macros.casts.Gen.box(type, boxClass, "implicitUpcast", "implicitDowncast", "boxF", "unboxF");
  }
  
}