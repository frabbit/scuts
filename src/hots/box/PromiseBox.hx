package hots.box;
import hots.In;

import hots.instances.KleisliOf;
import hots.instances.PromiseOf;
import scuts.core.types.Promise;

class PromiseBox 
{
  public static inline function asKleisli <M,A,B>(f:A->Promise<B>):KleisliOf<Promise<In>,A,B> return cast f
  
  public static inline function runKleisli <M,A,B>(f:KleisliOf<Promise<In>,A,B>):A->Promise<B> return cast f
  
  public static inline function box <X>(o:Promise<X>):PromiseOf<X> return cast o
  
  public static inline function unbox <X>(o:PromiseOf<X>):Promise<X> return cast o
  
  public static inline function boxF <X,XX>(o:X->Promise<XX>):X->PromiseOf<XX> return cast o
  
  public static inline function unboxF <X,XX>(o:X->PromiseOf<XX>):X->Promise<XX> return cast o
  
}