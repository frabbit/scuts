package hots.box;
import hots.instances.ArrayOf;
import hots.instances.FutureOf;
import hots.instances.OptionOf;
import hots.instances.OptionTOf;
import hots.macros.Box;
import scuts.core.types.Future;
import scuts.core.types.Option;


class FutureBox 
{
  public static inline function box <X>(o:Future<X>):FutureOf<X> return Box.box(o)
  
  public static inline function unbox <X>(o:FutureOf<X>):Future<X> return Box.unbox(o)
  
  public static inline function boxF <X,XX>(o:X->Future<XX>):X->FutureOf<XX> return Box.boxF(o)
  
  public static inline function unboxF <X,XX>(o:X->FutureOf<XX>):X->Future<XX> return Box.unboxF(o)
  
}