package hots.box;
import hots.Of;
import hots.of.LazyListOf;
import hots.of.LazyListTOf;
import scuts.core.LazyList;


class LazyListBox 
{
  public static inline function boxT <A,B>(o:Of<A, LazyList<B>>):LazyListTOf<A,B> return o
  public static inline function unboxT <A,B>(o:LazyListTOf<A,B>):Of<A, LazyList<B>> return cast o 
  
  public static inline function boxFT <X,A,B>(o:X->Of<A, LazyList<B>>):X->LazyListTOf<A,B> return o
  public static inline function unboxFT <X,A,B>(o:X->LazyListTOf<A,B>):X->Of<A, LazyList<B>> return cast o 
  
  
  public static inline function box <A>(m:LazyList<A>):LazyListOf<A> return m
  public static inline function unbox <A>(m:LazyListOf<A>):LazyList<A> return m
  
  public static inline function box0 <A>(m:Void->LazyList<A>):Void->LazyListOf<A> return m
  public static inline function unbox0 <A>(m:Void->LazyListOf<A>):Void->LazyList<A> return m

  public static inline function boxF <A,B>(f:A->LazyList<B>):A->LazyListOf<B> return f
  public static inline function unboxF <A,B>(f:A->LazyListOf<B>):A->LazyList<B> return f
}