package hots.box;
import hots.In;
import hots.of.ArrayOf;
import hots.of.ArrayTOf;
import hots.of.KleisliOf;
import hots.of.LazyTOf;

import hots.Of;



class LazyBox 
{
  

  // Normal Boxing into Array Transformer
  
  public static inline function boxT <X,Y>(a:Void->Of<X, Y>):LazyTOf<X,Y> return a
  
  public static inline function unboxT <X,Y>(a:LazyTOf<X,Y>):Void->Of<X, Y> return a
  
  // Function Boxing into Array Transformer
  
  public static inline function boxFT <A,X,Y>(a:A->(Void->Of<X, Y>)):A->LazyTOf<X,Y> return a
  
  public static inline function unboxFT <A,X,Y>(a:A->LazyTOf<X,Y>):A->(Void->Of<X, Y>) return a
}