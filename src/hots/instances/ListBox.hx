package hots.instances;
import hots.instances.ListOf;

class ListBox
{
  public static inline function box <A>(m:List<A>):ListOf<A> return cast m
  public static inline function unbox <A>(m:ListOf<A>):List<A> return cast m

  public static inline function boxF <A,B>(f:A->List<B>):A->ListOf<A> return cast f
  public static inline function unboxF <A,B>(f:A->ListOf<B>):A->List<B> return cast f
}