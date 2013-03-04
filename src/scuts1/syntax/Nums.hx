package scuts1.syntax;

import scuts1.classes.Num;

class Nums
{
  public static inline function plus   <A>(a:A, b:A, n:Num<A>):A return n.plus(a,b);
  public static inline function mul    <A>(a:A, b:A, n:Num<A>):A return n.mul(a,b);
  public static inline function minus  <A>(a:A, b:A, n:Num<A>):A return n.minus(a,b);
  public static inline function negate <A>(a:A, n:Num<A>):A      return n.negate(a);
  public static inline function abs    <A>(a:A, n:Num<A>):A      return n.abs(a);
  public static inline function signum <A>(a:A, n:Num<A>):A      return n.signum(a);
  public static inline function fromInt <A>(a:Int, n:Num<A>):A return n.fromInt(a);
}
