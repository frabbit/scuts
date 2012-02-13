package hots.instances;
import haxe.FastList;
import hots.instances.FastListOf;
import scuts.core.types.Option;

class BoxFastList 
{
  public static inline function box <A>(m:FastList<A>):FastListOf<A> return cast m
  public static inline function unbox <A>(m:FastListOf<A>):FastList<A> return cast m

  public static inline function boxF <A,B>(f:A->FastList<B>):A->FastListOf<A> return cast f
  public static inline function unboxF <A,B>(f:A->FastListOf<B>):A->FastList<B> return cast f
  
}