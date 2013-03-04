package scuts1.syntax;

import haxe.macro.Expr;
import scuts1.macros.syntax.DoTools;


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
  
}