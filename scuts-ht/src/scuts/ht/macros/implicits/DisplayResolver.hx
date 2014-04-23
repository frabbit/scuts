package scuts.ht.macros.implicits;

#if macro


import haxe.macro.Expr;
import haxe.macro.Context;


class DisplayResolver
{
  public static var helper(default, null) = macro scuts.ht.macros.syntax.DoHelper;

  public static function resolve (f:Expr, args:Array<Expr>, ?numArgs:Int = -1):Expr
  {
   if (numArgs == null) numArgs == -1;


    var numArgsNew:Int = if (numArgs != -1) {
      numArgs;
    } else {
      var t = try Context.typeof(f) catch (e:Dynamic) null;

      if (t != null) {
        switch (t) {
          case TFun(fargs, _):
            var x : Int = fargs.length; x;
          case _ : var x : Int = -1; x;

        }
      } else { var x : Int = -1; x; }
    }


    var numArgsNew = -1;



    var t1:Expr = if (numArgsNew != -1) {

      var len = numArgsNew - args.length;
      var hasWildCards = false;
      for (a in args) {
        switch (a.expr) {
          case EConst(CIdent("_")):
            hasWildCards = true;
            break;
          case _:
        }
      }
      for (_ in 0...len) {
        args.push(macro null);
      }
      var f1:Expr = if (hasWildCards) macro $f.bind else f;

      var x : Expr = macro $f1($a{args});
      x;

    } else {

      var x : Expr = macro $f($a{args});
      x;
    }
    return t1;

  }

  public static function resolveImplicitObjByType (t:String):Expr
  {
    return Context.parse(" { var e : " + t + " = null; e; } ", Context.currentPos());
  }

  public static function resolveImplicitObj (required:Expr) {
    return required;
  }

}

#end