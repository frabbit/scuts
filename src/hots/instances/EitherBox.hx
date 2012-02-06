package hots.instances;

import scuts.core.types.Either;

class EitherBox 
{

  public static function box <L,R>(a:Either<L,R>):EitherOf<L,R> return cast a
  
  public static function unbox <L,R>(a:EitherOf<L,R>):Either<L,R> return cast a
  
}