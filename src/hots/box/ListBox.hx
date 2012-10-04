package hots.box;

import hots.In;
import hots.Of;
import hots.of.ListOf;



class ListBox 
{

  public static inline function box <X>(a:List<X>):ListOf<X> return a
  
  public static inline function unbox <X>(a:ListOf<X>):List<X> return a
  
  public static inline function boxF <X,Y>(a:X->List<Y>):X->ListOf<Y> return a
  
  public static inline function unboxF <A,B>(e:A->ListOf<B>):A->List<B> return e
  
  
}