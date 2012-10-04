package hots.box;
import hots.In;
import hots.of.IoOf;
import hots.of.KleisliOf;


import hots.Of;
import scuts.core.types.Io;


class IoBox 
{
  public static inline function asKleisli <M,A,B>(f:A->Io<B>):KleisliOf<Io<In>,A,B> return cast f
  
  public static inline function runKleisli <M,A,B>(f:KleisliOf<Io<In>,A,B>):A->Io<B> return cast f
  
  public static inline function box <X>(o:Io<X>):IoOf<X> return cast o

  public static inline function unbox <X>(o:IoOf<X>):Io<X> return cast o
  
  public static inline function boxF <A,B>(o:A->Io<B>):A->IoOf<B> return cast o 
  
  public static inline function unboxF <A,B>(o:A->IoOf<B>):A->Io<B> return cast o 
}