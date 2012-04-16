package hots.box;
import hots.In;
import hots.instances.Tup2LeftOf;
import hots.instances.Tup2RightOf;
import hots.Of;
import scuts.core.types.Tup2;

extern class Tup2Box {
  public static inline function boxLeft <L,R>(m:Tup2<L,R>):Tup2LeftOf<L,R> return cast m
  public static inline function unboxLeft <L,R>(m:Tup2LeftOf<L,R>):Tup2<L,R> return cast m

  public static inline function boxLeftF <A,L,R>(f:A->Tup2<L,R>):A->Tup2LeftOf<L,R> return cast f
  public static inline function unboxLeftF <A,L,R>(f:A->Tup2LeftOf<L,R>):A->Tup2<L,R> return cast f
  
  public static inline function boxRight <L,R>(m:Tup2<L,R>):Tup2RightOf<L,R> return cast m
  public static inline function unboxRight <L,R>(m:Tup2RightOf<L,R>):Tup2<L,R> return cast m

  public static inline function boxRightF <A,L,R>(f:A->Tup2<L,R>):A->Tup2RightOf<L,R> return cast f
  public static inline function unboxRightF <A,L,R>(f:A->Tup2RightOf<L,R>):A->Tup2<L,R> return cast f
}
