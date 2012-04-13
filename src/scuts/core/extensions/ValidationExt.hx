package scuts.core.extensions;

import scuts.core.types.Option;
import scuts.core.types.Validation;
import scuts.Scuts;
import scuts.core.types.Either;

typedef ValidationArray<A,B> = Validation<Array<A>, B>;


class ValidationExt
{
  public static function either<F,S>(v:Validation<F,S>):Either<F,S> {
    return switch (v) {
      case Failure(f): Left(f);
      case Success(s): Right(s);
    }
  }
  
  public static function bool<F,S>(v:Validation<F,S>):Bool {
    return switch (v) {
      case Failure(_): false;
      case Success(_): true;
    }
  }
  
  public static function apply <F,S,SS> (v:Validation<F,S>, f:Validation<F, S->SS>, appendFailure:F->F->F):Validation<F, SS>
  {
    return switch (f) {
      case Success(s1): switch (v) {
        case Success(s2): Success(s1(s2));
        case Failure(f): Failure(f);
      }
        
      case Failure(f1): switch (v) {
        case Success(s): Failure(f1);
        case Failure(f2): Failure(appendFailure(f1, f2));
      }
    }
  }
  
  public static function append <F,S,SS> (a1:Validation<F,S>, a2:Validation<F, S>, appendFailure:F->F->F, appendSuccess:S->S->S):Validation<F, S>
  {
    return switch (a1) {
      case Success(s1): switch (a2) {
        case Success(s2): Success(appendSuccess(s1,s2));
        case Failure(f): Failure(f);
      }
        
      case Failure(f1): switch (a2) {
        case Success(s): Failure(f1);
        case Failure(f2): Failure(appendFailure(f1, f2));
      }
    }
  }
  
  public static function getOrElse<F,S>(v:Validation<F,S>, withFailure:F->S):S
  {
    return switch (v) {
      case Failure(f): withFailure(f);
      case Success(s): s;
    }
  }
  
  public static function ifFailure<F,S,FF>(v:Validation<F,S>, f:Void->Validation<FF,S>):Validation<FF,S>
  {
    return switch (v) {
      case Failure(_): f();
      case Success(_): cast v;
    }
  }
  
  public static function ifSuccess<F,S,SS>(v:Validation<F,S>, f:Void->Validation<F,SS>):Validation<F,SS>
  {
    return switch (v) {
      case Failure(_): cast v;
      case Success(_): f();
    }
  }
  
  /**
   * Returns the left value of e or throws an error if it's a right Validation.
   * 
   * @param e Validation Instance
   * @return the left Side of e 
   */
  public static function extract<F,S>(v:Validation<F,S>):S 
  {
    return switch (v) {
      case Failure(_): Scuts.error("Validation has no Success value");
      case Success(s): s;
    }
  }
  
  /**
   * Returns the right value of e or throws an error if it's a left Validation.
   */
  public static function extractFailure<F,S>(v:Validation<F,S>):F 
  {
    return switch (v) {
      case Failure(f): f;
      case Success(_): Scuts.error("Validation has no Failure value");
    }
  }
  
  /**
   * Converts the right value of e into an Option.
   */
  public static function option<F,S>(v:Validation<F,S>):Option<S>
  {
    return switch (v) {
      case Failure(_): None;
      case Success(s): Some(s);
    }
  }
  
  /**
   * Converts the left value of e into an Option.
   */
  public static function optionFailure<F,S>(v:Validation<F,S>):Option<F> 
  {
    return switch (v) {
      case Failure(f): Some(f);
      case Success(_): None;
    }
  }
  
  public static function each < A, B> (v:Validation< A, B> , f:B->Void):Void {
    switch (v) {
      case Failure(_):
      case Success(s): f(s);
    }
  }
  
  public static function eachFailure < A, B> (v:Validation< A, B> , f:A->Void):Void {
    switch (v) {
      case Failure(fe):f(fe);
      case Success(_):
    }
  }

  /**
   * Returns true if e is Left Validation.
   */
  public static function isSuccess<F,S>(v:Validation<F,S>):Bool
  {
    return switch (v) {
      case Failure(_): false;
      case Success(_): true;
    }
  }
  
 
  /**
   * Returns if e is Right Validation.
   */
  public static inline function isFailure<F,S>(e:Validation<F,S>):Bool
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
  /*
  public static function flatMapBoth < A,B,C,D > (o:Validation<A,B>, onFailure:A->Validation<C, D>, onSuccess:B->Validation<C,D>):Validation<C,D>
  {
    // this implementation performs better than flatten(map(o, leftF, rightF))
    
    return switch (o) {
      case Failure(v): onFailure(v);
      case Success(v): onSuccess(v);
    }
  }
  */
  
  public static function toVA <A,B> (o:Validation<A,B>):Validation<Array<A>, B>
  {
    return mapFailure(o, function (x) return [x]);
  }
  /*
  public static function failVA <A,B> (o:A):Validation<Array<A>, B>
  {
    return Failure([o]);
  }
  */
  
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
   * Maps the right side of an Validation with the function rightF and flattens the result. 
   * 
   * @param e Validation instance to flatMap
   * @param rightF the Mapping function
   * 
   * @return flatMapped Validation instance
   */
  public static function flatMap <F,S,SS> (o:Validation<F,S>, f:S->Validation<F, SS>):Validation<F,SS>
  {
    // this implementation performs better than flattenRight(mapRight(o, rightF))
    return switch (o) {
      case Failure(_): cast o; // avoids creating a new object
      case Success(v): f(v);
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
  public static function flatMapFailure < F,S,FF > (o:Validation<F,S>, f:F->Validation<FF, S>):Validation<FF,S>
  {
    // this implementation performs better than flattenLeft(mapLeft(o, rightF))
    return switch (o) {
      case Failure(v): f(v);
      case Success(_): cast o; // avoids creating a new object
    }
  }
  
  
  
  
  /**
   * Flattens both sides of an Validation.
   * 
   * @param e Validation instance to flatten
   * 
   * @return flattened Validation instance
   */
  /*
  public static function flattenBoth <A,B> (e:Validation<Validation<A,B>, Validation<A,B>>):Validation<A,B> {
    return switch (e) {
      case Failure(l): l;
      case Success(r): r;
    }
  }
  */
  
  /**
   * Flattens the right side of an Validation.
   * 
   * @param e Validation instance to flatten
   * 
   * @return flattened Validation instance
   */
  public static function flatten <F,S> (v:Validation<F, Validation<F,S>>):Validation<F,S> {
    return switch (v) {
      case Failure(_): cast v;
      case Success(s): s;
    }
  }
  
  /**
   * Flattens the left side of an Validation.
   * 
   * @param e Validation instance to flatten
   * 
   * @return flattened Validation instance
   */
  public static function flattenFailure <F,S> (v:Validation<Validation<F,S>, S>):Validation<F,S> {
    return switch (v) {
      case Failure(f): f;
      case Success(_): cast v;
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
  public static function map < F,S,SS > (v:Validation<F,S>, f:S->SS):Validation<F,SS>
  {
    return switch (v) {
      case Failure(_): cast v; // avoids creating a new object
      case Success(s): Success(f(s));
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
  public static function mapFailure < F,S,FF > (v:Validation<F,S>, f:F->FF):Validation<FF,S>
  {
    return switch (v) {
      case Failure(l): Failure(f(l));
      case Success(_): cast v; // avoids creating a new object
    }
  }
  
  public static inline function fail <A,B>(v:Validation<A,B>):FailProjection<A,B> return cast v
  
}


using scuts.core.extensions.ValidationExt;

class FailProjectionExt 
{
  public static inline function success <F,S>(v:FailProjection<F,S>):Validation<F,S> return cast v
  
  public static inline function map <F,S,FF> (v:FailProjection<F,S> , f:F->FF):FailProjection<FF,S> 
  {
    return success(v).mapFailure(f).fail();
  }
  
  public static inline function flatMap <F,S,FF> (v:FailProjection<F,S> , f:F->Validation<FF,S>):FailProjection<FF,S> 
  {
    return success(v).flatMapFailure(f).fail();
  }
  
  public static inline function flatten <F,S> (v:FailProjection<Validation<F,S>, S>):FailProjection<F,S> 
  {
    return success(v).flattenFailure().fail();
  }
  
  public static inline function isSuccess<F,S>(v:FailProjection<F,S>):Bool
  {
    return success(v).isSuccess();
  }
  
  public static inline function isFailure<F,S>(v:FailProjection<F,S>):Bool
  {
    return success(v).isFailure();
  }
  
  public static inline function option<F,S>(v:FailProjection<F,S>):Option<F>
  {
    return success(v).optionFailure();
  }
  
  public static inline function each < F,S> (v:FailProjection< F,S> , f:F->Void):Void 
  {
    return success(v).eachFailure(f);
  }
  
  public static inline function extract<F,S>(v:FailProjection<F,S>):F 
  {
    return success(v).extractFailure();
  }
}

class ValidationEitherConversions 
{
  public static function validation<L,R>(e:Either<L,R>):Validation<L,R> 
  {
    return switch (e) {
      case Left(l): Failure(l);
      case Right(r): Success(r);
    }
  }
}

class ValidationOptionConversions 
{
  public static function validation<F,S>(o:Option<S>, f:Void->F):Validation<F,S> 
  {
    return switch (o) {
      case Some(s): Success(s);
      case None:    Failure(f());
    }
  }
}

class ValidationDynamicConversions 
{
  public static function toSuccess<F,S>(x:S):Validation<F,S> 
  {
    return Success(x);
  }

  public static function toFail<F,S>(x:F):Validation<F,S> 
  {
    return Failure(x);
  }
  
  public static function nullToSuccess<F,S>(x:S, f:Void->F):Validation<F,S> 
  {
    return if (x != null) Success(x) else Failure(f());
  }
}