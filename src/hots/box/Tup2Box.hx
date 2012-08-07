package hots.box;
import hots.In;
import hots.instances.Tup2LeftOf;
import hots.instances.Tup2RightOf;
import hots.Of;
import scuts.core.types.Tup2;

extern class Tup2Box 
{
  public static inline function box1 <L,R>(m:Tup2<L,R>):Tup2LeftOf<L,R> return cast m
  
  public static inline function box1F <A,L,R>(f:A->Tup2<L,R>):A->Tup2LeftOf<L,R> return cast f
  
  public static inline function box2 <L,R>(m:Tup2<L,R>):Tup2RightOf<L,R> return cast m

  public static inline function box2F <A,L,R>(f:A->Tup2<L,R>):A->Tup2RightOf<L,R> return cast f
  
}

extern class Tup2_1Box 
{
  public static inline function unbox <L,R>(m:Tup2LeftOf<L,R>):Tup2<L,R> return cast m
  public static inline function unboxF <A,L,R>(f:A->Tup2LeftOf<L,R>):A->Tup2<L,R> return cast f
}

extern class Tup2_2Box 
{
  public static inline function unbox <L,R>(m:Tup2RightOf<L,R>):Tup2<L,R> return cast m
  public static inline function unboxF <A,L,R>(f:A->Tup2RightOf<L,R>):A->Tup2<L,R> return cast f
}
