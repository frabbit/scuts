package hots.box;

import hots.of.EitherOf;
import scuts.core.types.Either;



extern class EitherRightProjectionBox {
  
  public static inline function box <L,R>(a:RightProjection<L,R>):RightProjectionOf<L,R> return a
  
  public static inline function unbox <L,R>(a:RightProjectionOf<L,R>):RightProjection<L,R> return a
  
  public static inline function boxF <X,L,R>(a:X->RightProjection<L,R>):X->RightProjectionOf<L,R> return a
  
  public static inline function unboxF <X,L,R>(a:X->RightProjectionOf<L,R>):X->RightProjection<L,R> return a
}

extern class EitherLeftProjectionBox {
  
  public static inline function box <L,R>(a:LeftProjection<L,R>):LeftProjectionOf<L,R> return a
  
  public static inline function unbox <L,R>(a:LeftProjectionOf<L,R>):LeftProjection<L,R> return a
  
  public static inline function boxF <X,L,R>(a:X->LeftProjection<L,R>):X->LeftProjectionOf<L,R> return a
  
  public static inline function unboxF <X,L,R>(a:X->LeftProjectionOf<L,R>):X->LeftProjection<L,R> return a
}