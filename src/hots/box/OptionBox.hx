package hots.box;
import hots.In;

import hots.Of;
import hots.of.KleisliOf;
import hots.of.OptionOf;
import hots.of.OptionTOf;
import scuts.core.Option;


class OptionBox 
{
  
  public static inline function box <X>(x:Option<X>):OptionOf<X> return x

  public static inline function unbox <X>(x:OptionOf<X>):Option<X> return x
  
  public static inline function box0 <X>(x:Void->Option<X>):Void->OptionOf<X> return x

  public static inline function unbox0 <X>(x:Void->OptionOf<X>):Void->Option<X> return x
  
  public static inline function boxF <A,B>(x:A->Option<B>):A->OptionOf<B> return x
  
  public static inline function unboxF <A,B>(x:A->OptionOf<B>):A->Option<B> return x
  
  
  public static inline function boxT <A,B>(x:Of<A, Option<B>>):OptionTOf<A,B> return x
  
  public static inline function unboxT <A,B>(x:OptionTOf<A,B>):Of<A, Option<B>> return cast x
  
    
    
  public static inline function boxFT <X,A,B>(f:X->Of<A, Option<B>>):X->OptionTOf<A,B> return f
  
  public static inline function unboxFT <X, A,B>(f:X->OptionTOf<A,B>):X->Of<A, Option<B>> return cast f 
  
}
