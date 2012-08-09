package hots.box;
import hots.In;
import hots.instances.ArrayOf;
import hots.instances.KleisliOf;
import hots.instances.OptionOf;
import hots.instances.OptionTOf;
import hots.Of;
import scuts.core.types.Option;


class OptionBox 
{
  public static inline function asKleisli <M,A,B>(f:A->Option<B>):KleisliOf<Option<In>,A,B> return cast f
  
  public static inline function runKleisli <M,A,B>(f:KleisliOf<Option<In>,A,B>):A->Option<B> return cast f
  
  public static function optionT <A,B>(o:Of<A, Option<B>>):OptionTOf<A,B> return boxT(o)
  
  public static function runT <A,B>(o:OptionTOf<A,B>):Of<A, Option<B>> return unboxT(o) 
  
  public static inline function box <X>(o:Option<X>):OptionOf<X> return cast o

  public static inline function unbox <X>(o:OptionOf<X>):Option<X> return cast o
  
  public static inline function boxF <A,B>(o:A->Option<B>):A->OptionOf<B> return cast o 
  
  public static inline function unboxF <A,B>(o:A->OptionOf<B>):A->Option<B> return cast o 
  
  public static inline function boxT <A,B>(o:Of<A, Option<B>>):OptionTOf<A,B> return cast o
  
  public static inline function unboxT <A,B>(o:OptionTOf<A,B>):Of<A, Option<B>> return cast o 
  
  public static inline function boxFT <X,A,B>(f:X->Of<A, Option<B>>):X->OptionTOf<A,B> return cast f
  
  public static inline function unboxFT <X, A,B>(f:X->OptionTOf<A,B>):X->Of<A, Option<B>> return cast f 
  
}
/*
class ArrayOptionBox {
  public static inline function boxT <A,B>(o:Array<Option<B>>):OptionTOf<Array<In>,B> return cast o
  
  public static inline function unboxT <A,B>(o:OptionTOf<Array<In>,B>):Array<Option<B>> return cast o 
}
*/