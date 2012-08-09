package hots.box;
import hots.instances.LazyListOf;
import hots.instances.LazyListTOf;
import hots.Of;
import scuts.data.LazyList;


class LazyListBox 
{
  public static inline function boxT <A,B>(o:Of<A, LazyList<B>>):LazyListTOf<A,B> return cast o
  public static inline function unboxT <A,B>(o:LazyListTOf<A,B>):Of<A, LazyList<B>> return cast o 
  
  
  public static inline function box <A>(m:LazyList<A>):LazyListOf<A> return cast m
  public static inline function unbox <A>(m:LazyListOf<A>):LazyList<A> return cast m

  public static inline function boxF <A,B>(f:A->LazyList<B>):A->LazyListOf<A> return cast f
  public static inline function unboxF <A,B>(f:A->LazyListOf<B>):A->LazyList<B> return cast f
}