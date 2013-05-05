package scuts.ht.core;



#if macro
#if !display
import scuts.ht.macros.implicits.Manager;
import scuts.Scuts;
#end
import scuts.ht.macros.implicits.Resolver;
import haxe.macro.Expr;


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
    #if display
    return null;
    #else
    return Manager.registerLocals(e);
    #end
  }

  @:noUsing 
  #if !macro macro #end public static function preservedCast (e:Expr):Expr 
  {
    return macro (inline function () return $e)();
  }
  @:noUsing 
  #if !macro macro #end public static function checkType (e:Expr):Expr 
  {
    
    return switch (e.expr) {
      case EVars([{ name : "_", type : t, expr : ex}]): { expr : ECheckType(ex, t), pos: e.pos};
      case _ : throw "Unexpected";

    }
    
    return macro (function () return $e)();
  }

  @:noUsing public static function identity <T>(t:T):T {
     return t;
  }

  @:noUsing 
  #if !macro macro #end public static function preservedCheckType (e:Expr):Expr 
  {
    return switch (e.expr) {
      case EVars([{ name : "_", type : t, expr : ex}]) if (t != null): 
        var e = macro (inline function ():$t return $ex)();
        //trace(haxe.macro.ExprTools.toString(e));
        return e;
      case _ : throw "Unexpected";

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
  #if !macro macro #end public static function _ (f:Expr, ?args:Array<Expr>):Expr 
  {
    
    return Resolver.resolve(f, args);
  }
  
  /**
   * Resolves implicit casts and objects and adds them to a function call.
   * 
   * Usage: Hots.resolve(myFunc, 1, 2)
   */
  @:noUsing #if !macro macro #end public static function resolve (f:Expr, ?args:Array<Expr>):Expr {
    return Resolver.resolve(f, args);
    
  }

  /**
   * Helper function to resolve function f on object o, prevents compiler inlining when f is defined as inline.
   * 
   * Usage: o.r_(myFunc, 1,2) instead of o.myFunc.resolve(1,2) or Hots.resolve(o.myFunc, 1, 2)
   * 
   */
  macro public static function r_ (o:Expr, f:Expr, ?args:Array<Expr>):Expr {
    return switch (f.expr) {
      case EConst(CIdent(i)): Resolver.resolve(macro $o.$i, args);
      case _: throw "the second parameter f must be a const ident";
    }
    
    
  }
}




