package hots.instances;
import hots.instances.ArrayOf;



class ArrayBox 
{
  public static inline function box <A>(m:Array<A>):ArrayOf<A> return cast m
  public static inline function unbox <A>(m:ArrayOf<A>):Array<A> return cast m

  public static inline function boxF <A,B>(f:A->Array<B>):A->ArrayOf<A> return cast f
  public static inline function unboxF <A,B>(f:A->ArrayOf<B>):A->Array<B> return cast f
}