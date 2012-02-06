package hots.instances;
import scuts.core.types.Option;


class OptionBox 
{
  public static inline function box <A>(m:Option<A>):OptionOf<A> return cast m
  public static inline function unbox <A>(m:OptionOf<A>):Option<A> return cast m

  public static inline function boxF <A,B>(f:A->Option<B>):A->OptionOf<A> return cast f
  public static inline function unboxF <A,B>(f:A->OptionOf<B>):A->Option<B> return cast f
}