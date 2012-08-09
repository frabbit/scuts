package hots.macros;

#if macro

import hots.Implicit;
import scuts.Scuts;
import hots.macros.generators.GenEq;
import hots.macros.ImplicitResolver;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.mcore.Print;
#end

class HotsMacros 
{
  public static function asImplicit <T>(a:T):Implicit<T> return cast a
  
  @:macro public static function monoidFor(t:String) 
  {
    return ImplicitResolver.implicitByType("hots.classes.Monoid<" + t + ">");
  }
  
  @:macro public static function implicitVal (e:Array<Expr>):Expr return ImplicitResolver.register(e)
  
  @:macro public static function implicitByType (type:String):Expr return ImplicitResolver.implicitByType(type)
  
  @:macro public static function genEq (type:Expr):Type return GenEq.forType(type)
  
  @:macro public static function _ (f:Expr, ?params:Array<Expr>):Expr {
    
    return ImplicitResolver.apply(f, params);
  }

  
}