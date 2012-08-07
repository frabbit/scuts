package hots.box;
import hots.instances.ImmutableListOf;
import hots.instances.LazyListOf;
import scuts.data.LazyList;
import scuts.data.List;


class ImmutableListBox 
{
  public static inline function box <A>(m:List<A>):ImmutableListOf<A> return cast m //Box.box(m)
  public static inline function unbox <A>(m:ImmutableListOf<A>):List<A> return cast m //Box.unbox(m)

  public static inline function boxF <A,B>(f:A->List<B>):A->ImmutableListOf<A> return cast f //Box.boxF(f)
  public static inline function unboxF <A,B>(f:A->ImmutableListOf<B>):A->List<B> return cast f// Box.unboxF(f)
}