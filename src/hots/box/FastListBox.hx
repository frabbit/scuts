package hots.box;
import haxe.FastList;
import hots.In;

import hots.of.FastListOf;
import haxe.FastList;


import hots.Of;



class FastListBox 
{
  
  public static inline function box <X>(a:FastList<X>):FastListOf<X> return a
  
  public static inline function unbox <X>(a:FastListOf<X>):FastList<X> return a
  
  public static inline function boxF <X,Y>(a:X->FastList<Y>):X->FastListOf<Y> return a
  
  public static inline function unboxF <A,B>(e:A->FastListOf<B>):A->FastList<B> return e
  
  
}