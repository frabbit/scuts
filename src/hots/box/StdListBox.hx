package hots.box;

import hots.In;
import hots.instances.StdListOf;
import hots.instances.KleisliOf;
import hots.Of;



class StdListBox 
{
  
  public static inline function asKleisli <M,A,B>(f:A->List<B>):KleisliOf<List<In>,A,B> return cast f
  
  public static inline function runKleisli <M,A,B>(f:KleisliOf<List<In>,A,B>):A->List<B> return cast f
  
  public static inline function box <X>(a:List<X>):StdListOf<X> return cast a
  
  public static inline function unbox <X>(a:StdListOf<X>):List<X> return cast a
  
  public static inline function boxF <X,Y>(a:X->List<Y>):X->StdListOf<Y> return cast a
  
  public static inline function unboxF <A,B>(e:A->StdListOf<B>):A->List<B> return cast e
  
  
}