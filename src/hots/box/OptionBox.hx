package hots.box;
import hots.instances.ArrayOf;
import hots.instances.OptionOf;
import hots.instances.OptionTOf;
import hots.macros.Box;
import scuts.core.types.Option;


class OptionBox 
{
  public static inline function box <X>(o:Option<X>):OptionOf<X> return Box.box(o)
  
  public static inline function unbox <X>(o:OptionOf<X>):Option<X> return Box.unbox(o)
  
  public static inline function boxF <X,XX>(o:X->Option<XX>):X->OptionOf<XX> return cast o //Box.boxF(o)
  
  public static inline function unboxF <X,XX>(o:X->OptionOf<XX>):X->Option<XX> return cast o // Box.unboxF(o)
  
  public static inline function boxT <A,B>(o:Of<A, Option<B>>):OptionTOf<A,B> return Box.box(o)
  
  public static inline function unboxT <A,B>(o:OptionTOf<A,B>):Of<A, Option<B>> return Box.unbox(o)
}