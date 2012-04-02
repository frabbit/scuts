package scuts.core.extensions;

import scuts.core.types.Option;
import scuts.core.types.Validation;
import scuts.Scuts;
import scuts.core.types.Either;

typedef ValidationArray<A,B> = Validation<Array<A>, B>;


class ValidationExt
{
  public static function toEither<A,B>(e:Validation<A,B>):Either<A,B> {
    return switch (e) {
      case Failure(f): Left(f);
      case Success(s): Right(s);
    }
  }
  
  public static function toBool<A,B>(e:Validation<A,B>):Bool {
    return switch (e) {
      case Failure(_): false;
      case Success(_): true;
    }
  }
  
  public static function getOrElse<A,B>(e:Validation<A,B>, handler:A->B):B
  {
    return switch (e) {
      case Failure(l): handler(l);
      case Success(r): r;
    }
  }
  
  public static function ifFailure<A,B,C>(e:Validation<A,B>, f:Void->Validation<C,B>):Validation<C,B>
  {
    return switch (e) {
      case Failure(_): f();
      case Success(_): cast e;
    }
  }
  
  public static function ifSuccess<A,B,C>(e:Validation<A,B>, f:Void->Validation<A,C>):Validation<A,C>
  {
    return switch (e) {
      case Failure(_): cast e;
      case Success(_): f();
    }
  }
  
  /**
   * Returns the left value of e or throws an error if it's a right Validation.
   * 
   * @param e Validation Instance
   * @return the left Side of e 
   */
  public static function getSuccess<A,B>(e:Validation<A,B>):A 
  {
    return switch (e) {
      case Failure(l): l;
      case Success(_): Scuts.error("Validation has no left value");
    }
  }
  
  /**
   * Returns the right value of e or throws an error if it's a left Validation.
   */
  public static function getFailure<A,B>(e:Validation<A,B>):B 
  {
    return switch (e) {
      case Failure(_): Scuts.error("Validation has no right value");
      case Success(r): r;
    }
  }
  
  /**
   * Converts the left value of e into an Option.
   */
  public static function failureOption<A,B>(e:Validation<A,B>):Option<A> 
  {
    return switch (e) {
      case Failure(l): Some(l);
      case Success(_): None;
    }
  }
  
  
  
  /**
   * Converts the right value of e into an Option.
   */
  public static function successOption<A,B>(e:Validation<A,B>):Option<B>
  {
    return switch (e) {
      case Failure(_): None;
      case Success(r): Some(r);
    }
  }
  
 
  /**
   * Returns true if e is Left Validation.
   */
  public static function isSuccess<A,B>(e:Validation<A,B>):Bool
  {
    return switch (e) {
      case Failure(_): false;
      case Success(_): true;
    }
  }
  
 
  /**
   * Returns if e is Right Validation.
   */
  public static inline function isFailure<A,B>(e:Validation<A,B>):Bool
  {
    return !isSuccess(e);
  }
  
  
  /**
   * Maps both sides of an Validation with the functions leftF and rightF and flattens the result. 
   * 
   * @param e Validation instance to flatMap
   * @param leftF the mapping function for the left side
   * @param rightF the mapping function for the right side
   * 
   * @return flatMapped Validation instance
   */
  public static function flatMap < A,B,C,D > (o:Validation<A,B>, onFailure:A->Validation<C, D>, onSuccess:B->Validation<C,D>):Validation<C,D>
  {
    // this implementation performs better than flatten(map(o, leftF, rightF))
    
    return switch (o) {
      case Failure(v): onFailure(v);
      case Success(v): onSuccess(v);
    }
  }
  
  public static function toVA <A,B> (o:Validation<A,B>):Validation<Array<A>, B>
  {
    return mapFailure(o, function (x) return [x]);
  }
  
  public static function failVA <A,B> (o:A):Validation<Array<A>, B>
  {
    return Failure([o]);
  }
  
  public static function concatArrays <A,B> (o1:Validation<Array<A>,B>, o2:Validation<Array<A>,B>):Validation<Array<A>, B>
  {
    return switch (o1) {
      case Failure(f1):
        switch (o2) {
          case Failure(f2): Failure(f1.concat(f2));
          default: o1;
        }
      default: o1;
    }
  }
  
  /**
   * Maps the left side of an Validation with the function leftF and flattens the result. 
   * 
   * @param e Validation instance to flatMap
   * @param leftF the Mapping function
   * 
   * @return flatMapped Validation instance
   */
  public static function flatMapFailure < A,B,C,D > (o:Validation<A,B>, f:A->Validation<C, B>):Validation<C,B>
  {
    // this implementation performs better than flattenLeft(mapLeft(o, rightF))
    return switch (o) {
      case Failure(v): f(v);
      case Success(_): cast o; // avoids creating a new object
    }
  }
  
  
  /**
   * Maps the right side of an Validation with the function rightF and flattens the result. 
   * 
   * @param e Validation instance to flatMap
   * @param rightF the Mapping function
   * 
   * @return flatMapped Validation instance
   */
  public static function flatMapSuccess < A,B,C,D > (o:Validation<A,B>, f:B->Validation<A, C>):Validation<A,C>
  {
    // this implementation performs better than flattenRight(mapRight(o, rightF))
    return switch (o) {
      case Failure(_): cast o; // avoids creating a new object
      case Success(v): f(v);
    }
    
  }
  
  /**
   * Flattens both sides of an Validation.
   * 
   * @param e Validation instance to flatten
   * 
   * @return flattened Validation instance
   */
  public static function flatten <A,B> (e:Validation<Validation<A,B>, Validation<A,B>>):Validation<A,B> {
    return switch (e) {
      case Failure(l): l;
      case Success(r): r;
    }
  }
  
  /**
   * Flattens the left side of an Validation.
   * 
   * @param e Validation instance to flatten
   * 
   * @return flattened Validation instance
   */
  public static function flattenFailure <A,B> (e:Validation<Validation<A,B>, B>):Validation<A,B> {
    return switch (e) {
      case Failure(l): l;
      case Success(r): cast e;
    }
  }
  
  /**
   * Flattens the right side of an Validation.
   * 
   * @param e Validation instance to flatten
   * 
   * @return flattened Validation instance
   */
  public static function flattenSuccess <A,B> (e:Validation<A, Validation<A,B>>):Validation<A,B> {
    return switch (e) {
      case Failure(l): cast e;
      case Success(r): r;
    }
  }
  
  /**
   * Maps the left side of an Validation and returns a new Validation based on the mapping function f.
   * 
   * @param e Validation instance to map
   * @param f the mapping function if e is Left
   * 
   * @return mapped Validation instance
   */
  public static function mapFailure < A,B,C > (e:Validation<A,B>, f:A->C):Validation<C,B>
  {
    return switch (e) {
      case Failure(l): Failure(f(l));
      case Success(r): cast e; // avoids creating a new object
    }
  }
  
  /**
   * Maps the right side of an Validation and returns a new Validation based on the mapping function f.
   * 
   * @param e Validation instance to map
   * @param f the mapping function if e is Right
   * 
   * @return mapped Validation instance
   */
  public static function mapSuccess < A,B,C > (e:Validation<A,B>, f:B->C):Validation<A,C>
  {
    return switch (e) {
      case Failure(l): cast e; // avoids creating a new object
      case Success(r): Success(f(r));
    }
  }
  
 
  
  /**
   * Maps an Validation into a new one based on the mapping functions left and right.
   * 
   * @param left the mapping function if e is Left
   * @param right the mapping function if e is Right
   * 
   * @return mapped Validation instance
   */
  public static function map < A,B,C,D > (e:Validation<A,B>, onFailure:A->C, onSuccess:B->D):Validation<C,D>
  {
    return switch (e) {
      case Failure(l): Failure(onFailure(l));
      case Success(r): Success(onSuccess(r));
    }
  }
  
}