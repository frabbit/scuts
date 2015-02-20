package scuts.ht.macros.syntax;

#if macro

import haxe.macro.Expr;

import haxe.macro.ExprTools;

class DisplayDoTools {

  public static function buildWith (m : Expr, exprs:Array<Expr>) {
    return build(exprs);
  }

  public static function build (exprs:Array<Expr>)
  {
    return if (exprs.length > 0)
    {
      var x = switch (exprs[0].expr)
      {
        case EBinop(OpLte, _, x): x;
        case _ : exprs[0];
      }
      //trace(ExprTools.toString(x));
      macro {
        inline function asOf <M,A>(t:scuts.ht.core.M<A>):scuts.ht.core.M<A> return t;
        asOf($x);
      };
    } else {
      throw "Invalid number of Expressions for Do-Block";
    }
  }
}

#end