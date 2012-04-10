package hots.box;
import hots.instances.ArrayOf;
import hots.instances.ArrayTOf;
import hots.macros.Box;
import hots.Of;


class ArrayBox 
{
  public static inline function box <X>(a:Array<X>):ArrayOf<X> return Box.box(a)
  
  public static inline function unbox <X>(a:ArrayOf<X>):Array<X> return Box.unbox(a)
  
  public static inline function boxF <X,Y>(a:X->Array<Y>):X->ArrayOf<Y> return Box.boxF(a)
  
  public static inline function unboxF <X,Y>(a:X->ArrayOf<Y>):X->Array<Y> return Box.unboxF(a)
  
  public static inline function boxT <X,Y>(a:Of<X, Array<Y>>):ArrayTOf<X,Y> return Box.box(a)
  
  public static inline function unboxT <X,Y>(a:ArrayTOf<X,Y>):Of<X, Array<Y>> return Box.unbox(a)
}