package scuts.ht.core;

#if macro
import scuts.ht.macros.implicits.Manager;
import scuts.ht.macros.implicits.Resolver;
import haxe.macro.Expr;
import scuts.Scuts;
#end

class Hots
{

  /**
   * Marks a local Variable as available for implicit resolution.
   * 
   * Usage: Hots.implicit(someVal)
   */
  @:noUsing 
  macro public static function implicit (e:Array<Expr>):Expr 
  {
    return Manager.registerLocals(e);
  }

  @:noUsing 
  macro public static function preservedCast (e:Expr):Expr 
  {
    return macro (inline function () return $e)();
  }
  @:noUsing 
  macro public static function checkType (e:Expr):Expr 
  {
    return switch (e.expr) {
      case EVars([{ name : "_", type : t, expr : ex}]): { expr : ECheckType(ex, t), pos: e.pos};
      case _ : Scuts.unexpected();

    }
    return macro (function () return $e)();
  }

  public static function identity <T>(t:T):T {
    return t;
  }

  @:noUsing 
  macro public static function preservedCheckType (e:Expr):Expr 
  {
    return switch (e.expr) {
      case EVars([{ name : "_", type : t, expr : ex}]) if (t != null): 
        var e = macro (inline function ():$t return $ex)();
        //trace(haxe.macro.ExprTools.toString(e));
        return e;
      case _ : Scuts.unexpected();

    }
    
  }
  /**
   * Returns an implicit Object based on the type passed as argument.
   * 
   * Usage: Hots.implicitByType("scuts.ht.classes.Monad<Array<In>>");
   */
  @:noUsing 
  macro public static function implicitByType (type:String):Expr 
  {
    return Resolver.resolveImplicitObjByType(type);
  }
  
  /**
   * Short alias for resolve, should be used with "using".
   * 
   * Usage: myFunc._(1,2) instaed of myFunc.resolve(1,2) or Hots.resolve(myFunc, 1, 2)
   * 
   */
  macro public static function _ (f:Expr, ?params:Array<Expr>):Expr 
  {
    return Resolver.resolve(f, params);
  }
  
  /**
   * Resolves implicit casts and objects and adds them to a function call.
   * 
   * Usage: Hots.resolve(myFunc, 1, 2)
   */
  @:noUsing macro  public static function resolve (f:Expr, ?params:Array<Expr>):Expr {
    
    return Resolver.resolve(f, params);
  }
}

