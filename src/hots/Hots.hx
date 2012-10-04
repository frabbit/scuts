package hots;

#if macro
import hots.macros.implicits.Manager;
import hots.macros.implicits.Resolver;
import haxe.macro.Expr;
#end

class Hots
{

  /**
   * Marks a local Variable as available for implicit resolution.
   * 
   * Usage: Hots.implicit(someVal)
   */
  @:macro public static function implicit (e:Array<Expr>):Expr 
  {
    return Manager.registerLocals(e);
  }
  /**
   * Returns an implicit Object based on the type passed as argument.
   * 
   * Usage: Hots.implicitByType("hots.classes.Monad<Array<In>>");
   */
  @:macro public static function implicitByType (type:String):Expr 
  {
    return Resolver.resolveImplicitObjByType(type);
  }

  /**
   * Short alias for resolve, should be used with "using".
   * 
   * Usage: myFunc._(1,2) instaed of myFunc.resolve(1,2) or Hots.resolve(myFunc, 1, 2)
   * 
   */
  @:macro public static function _ (f:Expr, ?params:Array<Expr>):Expr 
  {
    return Resolver.resolve(f, params);
  }
  
  /**
   * Resolves implicit casts and objects and adds them to a function call.
   * 
   * Usage: Hots.resolve(myFunc, 1, 2)
   */
  @:macro public static function resolve (f:Expr, ?params:Array<Expr>):Expr {
    
    return Resolver.resolve(f, params);
  }
}

