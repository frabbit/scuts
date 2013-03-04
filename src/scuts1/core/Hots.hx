package scuts1.core;

#if macro
import scuts1.macros.implicits.Manager;
import scuts1.macros.implicits.Resolver;
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
  macro public static function safeCast (e:Expr, type:Expr):Expr 
  {
    return switch (type.expr) {
      case EVars(vars) if (vars.length == 1 && vars[0].type != null): return { expr : ECheckType(e, vars[0].type), pos : e.pos};
      case _: Scuts.error("Invalid cast type, should be var x:MyType");
    }
    
  }
  /**
   * Returns an implicit Object based on the type passed as argument.
   * 
   * Usage: Hots.implicitByType("scuts1.classes.Monad<Array<In>>");
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

