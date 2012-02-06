package hots.instances;
import hots.instances.IterableOf;

class IterableBox 
{
  public static inline function box <A>(m:Iterable<A>):IterableOf<A> return cast m
  public static inline function unbox <A>(m:IterableOf<A>):Iterable<A> return cast m

  public static inline function boxF <A,B>(f:A->Iterable<B>):A->IterableOf<A> return cast f
  public static inline function unboxF <A,B>(f:A->IterableOf<B>):A->Iterable<B> return cast f 
}