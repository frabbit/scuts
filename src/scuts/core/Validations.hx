package scuts.core;

import scuts.core.Option;
import scuts.core.Tup2;
import scuts.core.Tup3;
import scuts.core.Validation;
import scuts.Scuts;
import scuts.core.Either;


private typedef VD<F,S> = Validation<F,S>;

class Validations
{
  public static function eq<F,S> (v1:VD<F, S>, v2:VD<F,S>, eqFailure:F->F->Bool, eqSuccess:S->S->Bool) return switch (v1)
  {
    case Failure(f1): switch (v2)
    {
      case Failure(f2): eqFailure(f1, f2);
      case Success(_):  false;
    }
    case Success(s1): switch (v2)
    {
      case Failure(_):  false;
      case Success(s2): eqSuccess(s1,s2);
    }
  }
  
  public static function either<F,S>(v:VD<F,S>):Either<F,S> return switch (v) 
  {
    case Failure(f): Left(f);
    case Success(s): Right(s);
  }

  public static function bool<F,S>(v:VD<F,S>):Bool return switch (v) 
  {
    case Failure(_): false;
    case Success(_): true;
  }
  
  
  public static function 
  apply <F,S,SS> (v:VD<F,S>, f:VD<F, S->SS>, appendFailure:F->F->F):VD<F, SS> return switch (f) 
  {
    case Success(s1): switch (v) 
    {
      case Success(s2): Success(s1(s2));
      case Failure(f): Failure(f);
    }
    case Failure(f1): switch (v) 
    {
      case Success(_): Failure(f1);
      case Failure(f2): Failure(appendFailure(f1, f2));
    }
  }
  
  public static function 
  append <F,S,SS> (a1:VD<F,S>, a2:VD<F, S>, appendFailure:F->F->F, appendSuccess:S->S->S):VD<F, S> return switch (a1) 
  {
    case Success(s1): switch (a2) 
    {
      case Success(s2): Success(appendSuccess(s1,s2));
      case Failure(f): Failure(f);
    }
    case Failure(f1): switch (a2) 
    {
      case Success(s): Failure(f1);
      case Failure(f2): Failure(appendFailure(f1, f2));
    }
  }
  
  public static function getOrElse<F,S>(v:VD<F,S>, withFailure:F->S):S return switch (v) 
  {
    case Failure(f): withFailure(f);
    case Success(s): s;
  }
  
  public static function ifFailure<F,S,FF>(v:VD<F,S>, f:Void->VD<FF,S>):VD<FF,S> return switch (v) 
  {
    case Failure(_): f();
    case Success(s): Success(s);
  }
  
  public static function ifSuccess<F,S,SS>(v:VD<F,S>, f:Void->VD<F,SS>):VD<F,SS> return switch (v) 
  {
    case Failure(v): Failure(v);
    case Success(_): f();
  }
  
  /**
   * Returns the left value of e or throws an error if it's a right Validation.
   * 
   * @param e Validation Instance
   * @return the left Side of e 
   */
  public static function extract<F,S>(v:VD<F,S>):S return switch (v) 
  {
    case Failure(_): Scuts.error("Validation has no Success value");
    case Success(s): s;
  }
  
  /**
   * Returns the right value of e or throws an error if it's a left Validation.
   */
  public static function extractFailure<F,S>(v:VD<F,S>):F return switch (v) 
  {
    case Failure(f): f;
    case Success(_): Scuts.error("Validation has no Failure value");
  }
  
  /**
   * Converts the right value of e into an Option.
   */
  public static function option<F,S>(v:VD<F,S>):Option<S> return switch (v) 
  {
    case Failure(_): None;
    case Success(s): Some(s);
  }
  
  /**
   * Converts the left value of e into an Option.
   */
  public static function optionFailure<F,S>(v:VD<F,S>):Option<F> return switch (v) 
  {
    case Failure(f): Some(f);
    case Success(_): None;
  }
  
  public static function each < A, B> (v:VD< A, B> , f:B->Void):Void switch (v) 
  {
    case Failure(_):
    case Success(s): f(s);
  }
  
  public static function eachFailure < A, B> (v:VD< A, B> , f:A->Void):Void switch (v) 
  {
    case Failure(fe):f(fe);
    case Success(_):
  }

  /**
   * Returns true if e is Left Validation.
   */
  public static function isSuccess<F,S>(v:VD<F,S>):Bool return switch (v) 
  {
    case Failure(_): false;
    case Success(_): true;
  }
  
 
  /**
   * Returns if e is Right Validation.
   */
  public static inline function isFailure<F,S>(e:VD<F,S>):Bool
  {
    return !isSuccess(e);
  }
  

  
  /**
   * Maps the right side of an Validation with the function rightF and flattens the result. 
   * 
   * @param e Validation instance to flatMap
   * @param rightF the Mapping function
   * 
   * @return flatMapped Validation instance
   */
  public static inline function flatMap <F,S,SS> (o:VD<F,S>, f:S->VD<F, SS>):VD<F,SS> return switch o 
  {
    case Failure(f): Failure(f);
    case Success(v): f(v);
  }
  
  /**
   * Maps the left side of an Validation with the function leftF and flattens the result. 
   * 
   * @param e Validation instance to flatMap
   * @param leftF the Mapping function
   * 
   * @return flatMapped Validation instance
   */
  public static function flatMapFailure < F,S,FF > (o:VD<F,S>, f:F->VD<FF, S>):VD<FF,S> return switch o
  {
    case Failure(v): f(v);
    case Success(s): Success(s); // avoids creating a new object
  }
  
  
  
  /**
   * Flattens the right side of an Validation.
   * 
   * @param e Validation instance to flatten
   * 
   * @return flattened Validation instance
   */
  public static function flatten <F,S> (v:VD<F, VD<F,S>>):VD<F,S> return switch v
  {
    case Failure(f): Failure(f);
    case Success(s): s;
  }
  
  /**
   * Flattens the left side of an Validation.
   * 
   * @param e Validation instance to flatten
   * 
   * @return flattened Validation instance
   */
  public static function flattenFailure <F,S> (v:VD<VD<F,S>, S>):VD<F,S> return switch v 
  {
    case Failure(f): f;
    case Success(s): Success(s);
  }
  
  /**
   * Maps the right side of an Validation and returns a new Validation based on the mapping function f.
   * 
   * @param e Validation instance to map
   * @param f the mapping function if e is Right
   * 
   * @return mapped Validation instance
   */
  public static function map < F,S,SS > (v:VD<F,S>, f:S->SS):VD<F,SS> return switch v
  {
    case Failure(f): Failure(f);
    case Success(s): Success(f(s));
  }
  
  
  
  /**
   * Maps the left side of an Validation and returns a new Validation based on the mapping function f.
   * 
   * @param e Validation instance to map
   * @param f the mapping function if e is Left
   * 
   * @return mapped Validation instance
   */
  public static function mapFailure < F,S,FF > (v:VD<F,S>, f:F->FF):VD<FF,S> return switch v
  {
    case Failure(l): Failure(f(l));
    case Success(s): Success(s);
  }
  
  public static inline function fail <A,B>(v:VD<A,B>):FailProjection<A,B> return cast v
  
  static function zipVal2 <F,S1,S2>(s1:S1, v2:VD<F,S2>):VD<F,Tup2<S1,S2>> return switch v2
  {
    case Success(s2): Success(Tup2.create(s1,s2));
    case Failure(f):  Failure(f);
  }
  
  static function zipVal3 <F,S1,S2,S3>(s1:S1, s2:S2, v:VD<F,S3>):VD<F,Tup3<S1,S2, S3>> return switch v
  {
    case Success(s3): Success(Tup3.create(s1,s2,s3));
    case Failure(f):  Failure(f);
  }
  
  public static function zipWith <F,S1,S2,S3>(v1:VD<F,S1>, v2:VD<F,S2>, f:S1->S2->S3):VD<F,S3> return switch v1
  {
    case Success(s1): switch (v2) 
    {
      case Success(s2): Success(f(s1,s2));
      case Failure(f2): Failure(f2);
    }
    case Failure(f):  Failure(f);
  }
  
  public static function zip <F,S1,S2>(v1:VD<F,S1>, v2:VD<F,S2>):VD<F,Tup2<S1,S2>> return switch v1
  {
    case Success(s1): zipVal2(s1, v2);
    case Failure(f):  Failure(f);
  }
  
  public static function zipLazy <F,S1,S2>(v1:VD<F,S1>, v2:Void->VD<F,S2>):VD<F,Tup2<S1,S2>> return switch v1
  {
    case Success(s1): zipVal2(s1, v2());
    case Failure(f):  Failure(f);
  }
  
  public static function zipLazy3 <F,S1,S2,S3>(v1:VD<F,S1>, v2:Void->VD<F,S2>, v3:Void->VD<F,S3>):VD<F,Tup3<S1,S2,S3>> return switch v1
  {
    case Success(s1): switch v2() 
    {
      case Success(s2): zipVal3(s1, s2, v3());
      case Failure(f): Failure(f);
    }
    case Failure(f):  Failure(f);
  }
  
  
  public static function zip2 <F,S1,S2,S3>(v1:VD<F,S1>, v2:VD<F,S2>, v3:VD<F,S3>):VD<F,Tup3<S1,S2,S3>>
  {
    return zipLazy3(v1, Dynamics.thunk(v2), Dynamics.thunk(v3));
  }
}


using scuts.core.Validations;

private typedef FP<F,S> = FailProjection<F,S>;

class FailProjectionExt 
{
  public static inline function success <F,S>(v:FP<F,S>):VD<F,S> return cast v
  
  public static inline function map <F,S,FF> (v:FP<F,S> , f:F->FF):FP<FF,S> 
  {
    return success(v).mapFailure(f).fail();
  }
  
  public static inline function flatMap <F,S,FF> (v:FP<F,S> , f:F->VD<FF,S>):FP<FF,S> 
  {
    return success(v).flatMapFailure(f).fail();
  }
  
  public static inline function flatten <F,S> (v:FP<VD<F,S>, S>):FP<F,S> 
  {
    return success(v).flattenFailure().fail();
  }
  
  public static inline function isSuccess<F,S>(v:FP<F,S>):Bool
  {
    return success(v).isSuccess();
  }
  
  public static inline function isFailure<F,S>(v:FP<F,S>):Bool
  {
    return success(v).isFailure();
  }
  
  public static inline function option<F,S>(v:FP<F,S>):Option<F>
  {
    return success(v).optionFailure();
  }
  
  public static inline function each < F,S> (v:FP< F,S> , f:F->Void):Void 
  {
    return success(v).eachFailure(f);
  }
  
  public static inline function extract<F,S>(v:FP<F,S>):F 
  {
    return success(v).extractFailure();
  }
}

class ValidationFromEither
{
  public static function validation<L,R>(e:Either<L,R>):VD<L,R> return switch (e) 
  {
    case Left(l): Failure(l);
    case Right(r): Success(r);
  }
}

class ValidationFromOption
{
  public static function validation<F,S>(o:Option<S>, f:Void->F):VD<F,S> return switch (o) 
  {
    case Some(s): Success(s);
    case None:    Failure(f());
  }
}

class ValidationFromDynamic 
{
  public static function toSuccess<F,S>(x:S):VD<F,S> 
  {
    return Success(x);
  }

  public static function toFailure<F,S>(x:F):VD<F,S> 
  {
    return Failure(x);
  }
  
  public static function nullToSuccess<F,S>(x:S, f:Void->F):VD<F,S> 
  {
    return if (x != null) Success(x) else Failure(f());
  }
}