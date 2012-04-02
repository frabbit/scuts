package scuts.core.extensions;

import scuts.core.types.Option;
import scuts.core.types.Either;
import scuts.Scuts;
import scuts.core.types.Validation;

class EitherExt
{
  
  public static function toValidation<A,B>(e:Either<A,B>):Validation<A,B> {
    return switch (e) {
      case Left(f): Failure(f);
      case Right(s): Success(s);
    }
  }
  
  public static function toBool<A,B>(e:Either<A,B>):Bool {
    return switch (e) {
      case Left(_): false;
      case Right(_):true;
    }
  }
  
  public static function getOrElse<A,B>(e:Either<A,B>, handler:A->B):B
  {
    return switch (e) {
      case Left(l): handler(l);
      case Right(r): r;
    }
  }
  
  public static function orElse<A,B>(e:Either<A,B>, left:Void->Either<A,B>):Either<A,B>
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
  public static function left<A,B>(e:Either<A,B>):A 
  {
    return switch (e) {
      case Left(l): l;
      case Right(_): Scuts.error("Either has no left value");
    }
  }
  
  /**
   * Returns the right value of e or throws an error if it's a left Either.
   */
  public static function right<A,B>(e:Either<A,B>):B 
  {
    return switch (e) {
      case Left(_): Scuts.error("Either has no right value");
      case Right(r): r;
    }
  }
  
  /**
   * Converts the left value of e into an Option.
   */
  public static function leftOption<A,B>(e:Either<A,B>):Option<A> 
  {
    return switch (e) {
      case Left(l): Some(l);
      case Right(_): None;
    }
  }
  
  public static function ifLeft<A,B,C>(e:Either<A,B>, f:Void->Either<C,B>):Either<C,B>
  {
    return switch (e) {
      case Left(_): f();
      case Right(_): cast e;
    }
  }
  
  public static function ifRight<A,B,C>(e:Either<A,B>, f:Void->Either<A,C>):Either<A,C>
  {
    return switch (e) {
      case Left(_): cast e;
      case Right(_): f();
    }
  }
  
  
  /**
   * Converts the right value of e into an Option.
   */
  public static function rightOption<A,B>(e:Either<A,B>):Option<B>
  {
    return switch (e) {
      case Left(_): None;
      case Right(r): Some(r);
    }
  }
  
 
  
  /**
   * Returns true if e is Left Either.
   */
  public static function isLeft<A,B>(e:Either<A,B>):Bool
  {
    return switch (e) {
      case Left(_): true;
      case Right(_): false;
    }
  }

  
  /**
   * Returns if e is Right Either.
   */
  public static inline function isRight<A,B>(e:Either<A,B>):Bool
  {
    return !isLeft(e);
  }
  
  
  /**
   * Maps both sides of an Either with the functions leftF and rightF and flattens the result. 
   * 
   * @param e Either instance to flatMap
   * @param leftF the mapping function for the left side
   * @param rightF the mapping function for the right side
   * 
   * @return flatMapped Either instance
   */
  public static function flatMap < A,B,C,D > (o:Either<A,B>, leftF:A->Either<C, D>, rightF:B->Either<C,D>):Either<C,D>
  {
    // this implementation performs better than flatten(map(o, leftF, rightF))
    
    return switch (o) {
      case Left(v): leftF(v);
      case Right(v): rightF(v);
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
  public static function flatMapLeft < A,B,C,D > (o:Either<A,B>, leftF:A->Either<C, B>):Either<C,B>
  {
    // this implementation performs better than flattenLeft(mapLeft(o, rightF))
    return switch (o) {
      case Left(v): leftF(v);
      case Right(_): cast o; // avoids creating a new object
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
  public static function flatMapRight < A,B,C,D > (o:Either<A,B>, rightF:B->Either<A, C>):Either<A,C>
  {
    // this implementation performs better than flattenRight(mapRight(o, rightF))
    return switch (o) {
      case Left(_): cast o; // avoids creating a new object
      case Right(v): rightF(v);
    }
    
  }
  
  /**
   * Flattens both sides of an Either.
   * 
   * @param e Either instance to flatten
   * 
   * @return flattened Either instance
   */
  public static function flatten <A,B> (e:Either<Either<A,B>, Either<A,B>>):Either<A,B> {
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
  public static function flattenLeft <A,B> (e:Either<Either<A,B>, B>):Either<A,B> {
    return switch (e) {
      case Left(l): l;
      case Right(r): cast e;
    }
  }
  
  /**
   * Flattens the right side of an Either.
   * 
   * @param e Either instance to flatten
   * 
   * @return flattened Either instance
   */
  public static function flattenRight <A,B> (e:Either<A, Either<A,B>>):Either<A,B> {
    return switch (e) {
      case Left(l): cast e;
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
  public static function mapLeft < A,B,C > (e:Either<A,B>, f:A->C):Either<C,B>
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
  public static function mapRight < A,B,C > (e:Either<A,B>, f:B->C):Either<A,C>
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
  public static function map < A,B,C,D > (e:Either<A,B>, left:A->C, right:B->D):Either<C,D>
  {
    return switch (e) {
      case Left(l): Left(left(l));
      case Right(r): Right(right(r));
    }
  }
  
}