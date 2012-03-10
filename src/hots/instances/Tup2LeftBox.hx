package hots.instances;
import hots.In;
import hots.Of;
import scuts.core.types.Tup2;

class Tup2LeftBox {
  public static inline function box <L,R>(m:Tup2<L,R>):Tup2LeftOf<L,R> return cast m
  public static inline function unbox <L,R>(m:Tup2LeftOf<L,R>):Tup2<L,R> return cast m

  public static inline function boxF <A,L,R>(f:A->Tup2<L,R>):A->Tup2LeftOf<L,R> return cast f
  public static inline function unboxF <A,L,R>(f:A->Tup2LeftOf<L,R>):A->Tup2<L,R> return cast f
}
