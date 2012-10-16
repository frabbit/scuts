package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;
import scuts.mcore.Make;

using scuts.core.Arrays;

class ArrayExprs 
{
  
  public static inline function after(a:Array<Expr>, e:Expr):Array<Expr> return [e].concat(a)
  
  public static inline function then(a:Array<Expr>, e:Expr):Array<Expr> return a.concat([e])
  
  public static inline function toBlock(a:Array<Expr>, pos:Position):Expr return Make.block(a, pos)
  
  
}
#end