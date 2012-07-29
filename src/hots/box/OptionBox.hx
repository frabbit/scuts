package hots.box;
import hots.instances.ArrayOf;
import hots.instances.OptionOf;
import hots.instances.OptionTOf;
import hots.macros.Box;
import hots.Of;
import scuts.core.types.Option;


class OptionBox 
{
  public static inline function box <X>(o:Option<X>):OptionOf<X> {
    #if scutsDebug
    return Box.box(o);
    #else
    return cast o;
    #end
  }
  
  public static inline function unbox <X>(o:OptionOf<X>):Option<X> {
    #if scutsDebug
    return Box.unbox(o);
    #else
    return cast o;
    #end
  }
  
  public static inline function boxF <X,XX>(o:X->Option<XX>):X->OptionOf<XX> return cast o //Box.boxF(o)
  
  public static inline function unboxF <X,XX>(o:X->OptionOf<XX>):X->Option<XX> return cast o // Box.unboxF(o)
  
  public static inline function boxT <A,B>(o:Of<A, Option<B>>):OptionTOf<A,B> return Box.box(o)
  
  public static inline function unboxT <A,B>(o:OptionTOf<A,B>):Of<A, Option<B>> return Box.unbox(o)
}