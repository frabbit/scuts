package hots.box;
import hots.In;
import hots.of.ArrayOf;
import hots.of.ArrayTOf;
import hots.of.KleisliOf;

import hots.Of;



class ArrayBox 
{
  
    
  // Normal Boxing of Arrays
  
  public static inline function box <X>(a:Array<X>):ArrayOf<X> return a
  
  public static inline function unbox <X>(a:ArrayOf<X>):Array<X> return a
  
  // Normal Boxing of Arrays
  
  public static inline function box0 <X>(a:Void->Array<X>):Void->ArrayOf<X> return a
  
  public static inline function unbox0 <X>(a:Void->ArrayOf<X>):Void->Array<X> return a
  
  // Function Boxing of Arrays
  
  public static inline function boxF <X,Y>(a:X->Array<Y>):X->ArrayOf<Y> return a
  
  public static inline function unboxF <A,B>(e:A->ArrayOf<B>):A->Array<B> return e
  
  // Normal Boxing into Array Transformer
  
  public static inline function boxT <X,Y>(a:Of<X, Array<Y>>):ArrayTOf<X,Y> return a
  
  public static inline function unboxT <X,Y>(a:ArrayTOf<X,Y>):Of<X, Array<Y>> return cast a
  
  // Function Boxing into Array Transformer
  
  public static inline function boxFT <A,X,Y>(a:A->Of<X, Array<Y>>):A->ArrayTOf<X,Y> return a
  
  public static inline function unboxFT <A,X,Y>(a:A->ArrayTOf<X,Y>):A->Of<X, Array<Y>> return cast a
}