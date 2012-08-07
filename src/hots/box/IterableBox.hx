package hots.box;
import haxe.FastList;
import hots.In;
import hots.instances.IterableOf;

import hots.instances.KleisliOf;

import hots.Of;



class IterableBox 
{
  
  public static inline function asKleisli <M,A,B>(f:A->Iterable<B>):KleisliOf<Iterable<In>,A,B> return cast f
  
  public static inline function runKleisli <M,A,B>(f:KleisliOf<Iterable<In>,A,B>):A->Iterable<B> return cast f
  
  public static inline function box <X>(a:Iterable<X>):IterableOf<X> return cast a
  
  public static inline function unbox <X>(a:IterableOf<X>):Iterable<X> return cast a
  
  public static inline function boxF <X,Y>(a:X->Iterable<Y>):X->IterableOf<Y> return cast a
  
  public static inline function unboxF <A,B>(e:A->IterableOf<B>):A->Iterable<B> return cast e
  
  
}