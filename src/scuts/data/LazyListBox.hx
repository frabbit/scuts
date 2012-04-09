package scuts.data;

/**
 * ...
 * @author 
 */

class LazyListBox 
{
  public static inline function box <A>(m:LazyList<A>):LazyListOf<A> return cast m
  public static inline function unbox <A>(m:LazyListOf<A>):LazyList<A> return cast m

  public static inline function boxF <A,B>(f:A->LazyList<B>):A->LazyListOf<A> return cast f
  public static inline function unboxF <A,B>(f:A->LazyListOf<B>):A->LazyList<B> return cast f
}