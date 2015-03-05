package scuts.ht.core;



#if macro

#if !display

import scuts.ht.macros.implicits.Manager;


#end

import haxe.macro.Context;
import scuts.ht.macros.implicits.Resolver;
import haxe.macro.Expr;
#end

class Ht
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
    return macro null;
    #else
    return Manager.registerLocals(e);
    #end
  }


  @:noUsing public static function identity <T>(t:T):T {
     return t;
  }

  /**
   * Returns an implicit Object based on the type passed as argument.
   *
   * Usage: Hots.implicitByType("scuts.ht.classes.Monad<Array<_>>");
   */
  @:noUsing
  macro public static function implicitByType (type:String):Expr
  {
    return Resolver.resolveImplicitObjByType(type);
  }

  @:noUsing macro public static function implicitly (e:Expr):Expr
  {
    var s = switch (e.expr) {
      case EConst(CString(s)): s;
      case _ : throw "Parameter must be a Type as a constant string";"";
    }
    var e = Context.parse(" { var e : scuts.ht.core.Implicitly<" + s + "> = null; e; } ", Context.currentPos());
    var ct = switch (e.expr) {
      case EBlock([{expr:EVars(v)},_]): v[0].type;
      case _ : throw "cannot type " + s; null;
    }

    //return { expr : ECheckType(macro null, ct), pos: Context.currentPos()};
    return macro { var x : $ct = null; x; };
  }

  @:noUsing macro public static function implicitly2 ():Expr
  {

    return macro { var x : String = null; x; };
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




