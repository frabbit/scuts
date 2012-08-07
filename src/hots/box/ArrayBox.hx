package hots.box;
import hots.In;
import hots.instances.ArrayOf;
import hots.instances.ArrayTOf;
import hots.instances.KleisliOf;

import hots.Of;



class ArrayBox 
{
  
  public static inline function asKleisli <M,A,B>(f:A->Array<B>):KleisliOf<Array<In>,A,B> return cast f
  
  public static inline function runKleisli <M,A,B>(f:KleisliOf<Array<In>,A,B>):A->Array<B> return cast f
  
  public static inline function box <X>(a:Array<X>):ArrayOf<X> return cast a
  
  public static inline function unbox <X>(a:ArrayOf<X>):Array<X> return cast a
  
  public static inline function boxF <X,Y>(a:X->Array<Y>):X->ArrayOf<Y> return cast a
  
  public static inline function unboxF <A,B>(e:A->ArrayOf<B>):A->Array<B> return cast e
  
  public static inline function boxT <X,Y>(a:Of<X, Array<Y>>):ArrayTOf<X,Y> return cast a
  
  public static inline function unboxT <X,Y>(a:ArrayTOf<X,Y>):Of<X, Array<Y>> return cast a
}