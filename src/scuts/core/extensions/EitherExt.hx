package scuts.core.extensions;

import scuts.core.types.Option;
import scuts.core.types.Either;
import scuts.Scuts;
import scuts.core.types.Validation;

class EitherExt
{
  
  public static function applyLeft <L,R,LL>(e:Either<L,R>, f:Either<L->LL, R>):Either<LL, R>
  {
    return switch (f) {
      case Left(l1):
        switch (e) 
        {
          case Left(l2): Left(l1(l2)); // faster instead of Left(l2);
          case Right(_): cast e;
        }
      case Right(r1):
        switch (e) 
        {
          case Left(_): cast e;   // faster instead of Left(l);
          case Right(r2): cast e;
        }
    }
  }
  
  public static function applyRight <L,R,RR>(e:Either<L,R>, f:Either<L, R->RR>):Either<L, RR>
  {
    return switch (f) {
      case Left(l1):
        switch (e) 
        {
          case Left(_): cast e; 
          case Right(_): cast e;
        }
      case Right(r1):
        switch (e) 
        {
          case Left(_): cast e; 
          case Right(r2): Right(r1(r2));
        }
    }
  }
  
  public static function bool<L,R>(e:Either<L,R>):Bool 
  {
    return switch (e) {
      case Left(_): false;
      case Right(_):true;
    }
  }
  
  public static function getOrElse<L,R>(e:Either<L,R>, handler:L->R):R
  {
    return switch (e) {
      case Left(l): handler(l);
      case Right(r): r;
    }
  }
  
  public static function orElse<L,R>(e:Either<L,R>, left:Void->Either<L,R>):Either<L,R>
  {
    return switch (e) {
      case Left(_): left();
      case Right(_): e;
    }
  }
  
  /**
   * Returns the left value of e or throws an error if it's a right Either.
   * 
   * @param e Either Instance
   * @return the left Side of e 
   */
  public static function extractLeft<L,R>(e:Either<L,R>):L 
  {
    return switch (e) {
      case Left(l): l;
      case Right(_): Scuts.error("Either has no Left value");
    }
  }
  
  /**
   * Returns the right value of e or throws an error if it's a left Either.
   */
  public static function extractRight<L,R>(e:Either<L,R>):R 
  {
    return switch (e) {
      case Left(_): Scuts.error("Either has no Right value");
      case Right(r): r;
    }
  }
  
  /**
   * Converts the left value of e into an Option.
   */
  public static function optionLeft<L,R>(e:Either<L,R>):Option<L> 
  {
    return switch (e) {
      case Left(l): Some(l);
      case Right(_): None;
    }
  }
  
  public static function ifLeft<L,R,LL>(e:Either<L,R>, f:Void->Either<LL,R>):Either<LL,R>
  {
    return switch (e) {
      case Left(_): f();
      case Right(_): cast e;
    }
  }
  
  public static function ifRight<L,R,RR>(e:Either<L,R>, f:Void->Either<L,RR>):Either<L,RR>
  {
    return switch (e) {
      case Left(_): cast e;
      case Right(_): f();
    }
  }
  
  
  /**
   * Converts the right value of e into an Option.
   */
  public static function optionRight<L,R>(e:Either<L,R>):Option<R>
  {
    return switch (e) {
      case Left(_): None;
      case Right(r): Some(r);
    }
  }
  
 
  
  /**
   * Returns true if e is Left Either.
   */
  public static function isLeft<L,R>(e:Either<L,R>):Bool
  {
    return switch (e) {
      case Left(_): true;
      case Right(_): false;
    }
  }

  
  /**
   * Returns if e is Right Either.
   */
  public static inline function isRight<L,R>(e:Either<L,R>):Bool
  {
    return !isLeft(e);
  }
  
  
  /**
   * Maps both sides of an Either with the functions leftF and rightF and flattens the result. 
   * 
   * @param e Either instance to flatMap
   * @param fl the mapping function for the left side
   * @param fr the mapping function for the right side
   * 
   * @return flatMapped Either instance
   */
  public static function flatMap < L,R,LL,RR > (e:Either<L,R>, fl:L->Either<LL, RR>, fr:R->Either<LL,RR>):Either<LL,RR>
  {
    // this implementation performs better than flatten(map(o, leftF, rightF))
    return switch (e) {
      case Left(l): fl(l);
      case Right(r): fr(r);
    }
  }
  
  
  
  /**
   * Maps the left side of an Either with the function leftF and flattens the result. 
   * 
   * @param e Either instance to flatMap
   * @param leftF the Mapping function
   * 
   * @return flatMapped Either instance
   */
  public static function flatMapLeft < L,R,LL > (e:Either<L,R>, f:L->Either<LL, R>):Either<LL,R>
  {
    // this implementation performs better than flattenLeft(mapLeft(o, rightF))
    return switch (e) {
      case Left(l): f(l);
      case Right(_): cast e; // avoids creating a new object
    }
  }
  
  
  /**
   * Maps the right side of an Either with the function rightF and flattens the result. 
   * 
   * @param e Either instance to flatMap
   * @param rightF the Mapping function
   * 
   * @return flatMapped Either instance
   */
  public static function flatMapRight < L,R,RR > (e:Either<L,R>, f:R->Either<L, RR>):Either<L,RR>
  {
    // this implementation performs better than flattenRight(mapRight(o, rightF))
    return switch (e) {
      case Left(_): cast e; // avoids creating a new object
      case Right(r): f(r);
    }
    
  }
  
  /**
   * Flattens both sides of an Either.
   * 
   * @param e Either instance to flatten
   * 
   * @return flattened Either instance
   */
  public static function flatten <L,R> (e:Either<Either<L,R>, Either<L,R>>):Either<L,R> 
  {
    return switch (e) {
      case Left(l): l;
      case Right(r): r;
    }
  }
  
  /**
   * Flattens the left side of an Either.
   * 
   * @param e Either instance to flatten
   * 
   * @return flattened Either instance
   */
  public static function flattenLeft <L,R> (e:Either<Either<L,R>, R>):Either<L,R> 
  {
    return switch (e) {
      case Left(l): l;
      case Right(_): cast e;
    }
  }
  
  /**
   * Flattens the right side of an Either.
   * 
   * @param e Either instance to flatten
   * 
   * @return flattened Either instance
   */
  public static function flattenRight <L,R> (e:Either<L, Either<L,R>>):Either<L,R> {
    return switch (e) {
      case Left(_): cast e;
      case Right(r): r;
    }
  }
  
  /**
   * Maps the left side of an Either and returns a new Either based on the mapping function f.
   * 
   * @param e Either instance to map
   * @param f the mapping function if e is Left
   * 
   * @return mapped Either instance
   */
  public static function mapLeft < L,R,LL > (e:Either<L,R>, f:L->LL):Either<LL,R>
  {
    return switch (e) {
      case Left(l): Left(f(l));
      case Right(r): cast e; // avoids creating a new object
    }
  }
  
  /**
   * Maps the right side of an Either and returns a new Either based on the mapping function f.
   * 
   * @param e Either instance to map
   * @param f the mapping function if e is Right
   * 
   * @return mapped Either instance
   */
  public static function mapRight < L,R,RR > (e:Either<L,R>, f:R->RR):Either<L,RR>
  {
    return switch (e) {
      case Left(l): cast e; // avoids creating a new object
      case Right(r): Right(f(r));
    }
  }
  
  /**
   * Maps an Either into a new one based on the mapping functions left and right.
   * 
   * @param left the mapping function if e is Left
   * @param right the mapping function if e is Right
   * 
   * @return mapped Either instance
   */
  public static function map < L,R,LL,RR > (e:Either<L,R>, left:L->LL, right:R->RR):Either<LL,RR>
  {
    return switch (e) {
      case Left(l): Left(left(l));
      case Right(r): Right(right(r));
    }
  }
  
  public static inline function right <L,R>(e:Either<L,R>):RightProjection<L,R> return cast e
  public static inline function left <L,R>(e:Either<L,R>):LeftProjection<L,R> return cast e
}

private typedef E = EitherExt;

using scuts.core.extensions.EitherExt;

private typedef RP<L,R> = RightProjection<L,R>;
private typedef LP<L,R> = LeftProjection<L,R>;


class LeftProjectionExt 
{
  public static inline function either<L,R>(e:LP<L,R>):Either<L,R> return cast e
  
  public static inline function eitherF<L,R,LL>(e:L->LP<LL,R>):L->Either<LL,R> return cast e
  
  public static inline function right<L,R>(e:LP<L,R>):RP<L,R> return either(e).right()
  
  public static inline function flatMap < L,R,LL > (e:LP<L,R>, f:L->Either<LL, R>):LP<LL,R>
  {
    return e.either().flatMapLeft(f).left();
  }
  public static inline function map <L,R,LL> (e:LP<L,R>, f:L->LL) : LP<LL,R>
  {
    return e.either().mapLeft(f).left();
  }
  public static function apply <L,R,LL>(e:LP<L,R>, f:Either<L->LL, R>):LP<LL, R>
  {
    return e.either().applyLeft(f).left();
  }
  
  
}



class RightProjectionExt 
{
  public static inline function either<L,R>(e:RP<L,R>):Either<L,R> return cast e
  
  public static inline function eitherF<L,R,RR>(e:R->RP<L,RR>):R->Either<L,R> return cast e
  
  public static inline function left<L,R>(e:RP<L,R>):LP<L,R> return either(e).left()
  
  public static inline function flatMap < L,R,RR > (e:RP<L,R>, f:R->Either<L, RR>):RP<L,RR>
  {
    return e.either().flatMapRight(f).right();
  }
  
  public static inline function map < L,R,RR > (e:RP<L,R>, f:R->RR):RP<L,RR>
  {
    return e.either().mapRight(f).right();
  }
  
  public static inline function apply <L,R,RR>(e:RP<L,R>, f:Either<L, R->RR>):RP<L, RR>
  {
    return e.either().applyRight(f).right();
  }
}



class EitherDynamicConversions {
  /**
   * Converts v into an Either, based on the nulliness of v.
   * If v is null, right is used as the Right value for the resulting Either.
   */
  public static inline function nullToRightConst < A,B > (v:B, left:A):Either<A,B> {
    return v == null ? Left(left) : Right(v);
  }
  
  /**
   * Converts v into a left Either.
   */
  public static inline function toLeft < L,R > (l:L):Either<L,R> return Left(l)
  
  /**
   * Converts v into a right Either.
   */
  public static inline function toRight < L,R > (r:R):Either<L,R> return Right(r)
}