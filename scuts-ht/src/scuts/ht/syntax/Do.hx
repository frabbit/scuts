package scuts.ht.syntax;

#if macro

import haxe.macro.Expr;
import scuts.ht.macros.syntax.DoTools;

#end

class Do 
{
  /**
   * Creates a Monad Comprehension like the haskell do-Notation.
   * 
   * Examples:
   * 
   * This example needs access to an implicit Monad instance for Array.
   * Do.run(
   *  a <= [1,2,3], // flatmap/bind on [1,2,3]
   *  b <= [4,5,6], // flatmap/bind on [4,5,6]
   *  pure(a+b) // pure acts like return in haskell
   * )
   * 
   */
  @:noUsing macro public static function run<M>(exprs:Array<Expr>)
  {
    return DoTools.build(exprs);
  }

  @:noUsing macro public static function runWith<M>(m:Expr, exprs:Array<Expr>)
  {
    return DoTools.buildWith(m, exprs);
  }
  
}