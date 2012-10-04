package hots.box;
import hots.of.ImListOf;
import hots.of.ImListTOf;
import scuts.core.types.ImList;


class ImListBox 
{
  public static inline function box <A>(m:ImList<A>):ImListOf<A> return m
  public static inline function unbox <A>(m:ImListOf<A>):ImList<A> return m
  
  public static inline function box0 <A>(m:Void->ImList<A>):Void->ImListOf<A> return m
  public static inline function unbox0 <A>(m:Void->ImListOf<A>):Void->ImList<A> return m

  public static inline function boxF <A,B>(f:A->ImList<B>):A->ImListOf<B> return f
  public static inline function unboxF <A,B>(f:A->ImListOf<B>):A->ImList<B> return f
  
  public static inline function boxT   <M,A>(m:Of<M,ImList<A>>):ImListTOf<M,A> return m
  public static inline function unboxT <M,A>(m:ImListTOf<M,A>):Of<M,ImList<A>> return cast m
  
  public static inline function boxFT   <M,A,X>(m:X->Of<M,ImList<A>>):X->ImListTOf<M,A> return m
  public static inline function unboxFT <M,A,X>(m:X->ImListTOf<M,A>) :X->Of<M,ImList<A>> return cast m
}