package hots.box;
import hots.instances.LazyListOf;
import hots.macros.Box;
import scuts.data.LazyList;


class LazyListBox 
{
  public static inline function box <A>(m:LazyList<A>):LazyListOf<A> return Box.box(m)
  public static inline function unbox <A>(m:LazyListOf<A>):LazyList<A> return Box.unbox(m)

  public static inline function boxF <A,B>(f:A->LazyList<B>):A->LazyListOf<A> return Box.boxF(f)
  public static inline function unboxF <A,B>(f:A->LazyListOf<B>):A->LazyList<B> return Box.unboxF(f)
}