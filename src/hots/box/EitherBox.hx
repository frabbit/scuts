package hots.box;

import hots.instances.EitherOf;
import scuts.core.types.Either;

extern class EitherBox 
{
  public static inline function box <L,R>(a:Either<L,R>):EitherOf<L,R> return cast a
  
  public static inline function unbox <L,R>(a:EitherOf<L,R>):Either<L,R> return cast a
  
  public static inline function boxF <L,R,RR>(a:R->Either<L,RR>):R->EitherOf<L,RR> return cast a
  
  public static inline function unboxF <L,R,RR>(a:R->EitherOf<L,RR>):R->Either<L,RR> return cast a
  
}


extern class EitherRightProjectionBox {
  
  public static inline function box <L,R>(a:RightProjection<L,R>):RightProjectionOf<L,R> return cast a
  
  public static inline function unbox <L,R>(a:RightProjectionOf<L,R>):RightProjection<L,R> return cast a
}

extern class EitherLeftProjectionBox {
  
  public static inline function box <L,R>(a:LeftProjection<L,R>):LeftProjectionOf<L,R> return cast a
  
  public static inline function unbox <L,R>(a:LeftProjectionOf<L,R>):LeftProjection<L,R> return cast a
}