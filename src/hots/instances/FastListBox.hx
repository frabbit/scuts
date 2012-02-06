package hots.boxing;
import haxe.FastList;
import scuts.core.types.Option;
import hots.wrapper.MVal;

class BoxFastList 
{

  public static inline function box <A>(m:FastList<A>):MValFastList<A> return cast m
  public static inline function unbox <A>(m:MValFastList<A>):FastList<A> return cast m

  public static inline function boxF <A,B>(f:A->FastList<B>):A->MValFastList<A> return cast f
  public static inline function unboxF <A,B>(f:A->MValFastList<B>):A->FastList<B> return cast f
  
}