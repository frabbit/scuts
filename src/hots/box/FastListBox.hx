package hots.box;
import haxe.FastList;
import hots.In;
import hots.instances.FastListOf;

import hots.instances.KleisliOf;

import hots.Of;



class FastListBox 
{
  
  public static inline function asKleisli <M,A,B>(f:A->FastList<B>):KleisliOf<FastList<In>,A,B> return cast f
  
  public static inline function runKleisli <M,A,B>(f:KleisliOf<FastList<In>,A,B>):A->FastList<B> return cast f
  
  public static inline function box <X>(a:FastList<X>):FastListOf<X> return cast a
  
  public static inline function unbox <X>(a:FastListOf<X>):FastList<X> return cast a
  
  public static inline function boxF <X,Y>(a:X->FastList<Y>):X->FastListOf<Y> return cast a
  
  public static inline function unboxF <A,B>(e:A->FastListOf<B>):A->FastList<B> return cast e
  
  
}