package scuts.core;

import scuts.Scuts;

using scuts.core.Tuples;
using scuts.core.Eithers;
using scuts.core.Options;
using scuts.core.Validations;

private typedef VD<F,S> = Validation<F,S>;

enum Validation < F, S > {
  Failure(f:F);
  Success(s:S);
}

abstract FailProjection<F,S>(VD < F, S >) to VD<F,S> 
{
  public inline function new (v:VD<F,S>) {
    this = v;
  }
}

class Validations
{
  public static function eq<F,S> (v1:VD<F, S>, v2:VD<F,S>, eqFailure:F->F->Bool, eqSuccess:S->S->Bool) return switch [v1,v2]
  {
    case [Failure(f1), Failure(f2)]: eqFailure(f1, f2);
    case [Success(s1), Success(s2)]: eqSuccess(s1,s2);
    case _ : false;
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
  apply <F,S,SS> (v:VD<F,S>, f:VD<F, S->SS>, appendFailure:F->F->F):VD<F, SS> return switch [v, f] 
  {
    case [Success(s),  Success(f) ]: Success(f(s));
    case [Failure(e),  Success(_) ]: Failure(e);
    case [Success(_),  Failure(e) ]: Failure(e);
    case [Failure(e1), Failure(e2)]: Failure(appendFailure(e2, e1));
  }
  
  public static function 
  append <F,S,SS> (a1:VD<F,S>, a2:VD<F, S>, appendFailure:F->F->F, appendSuccess:S->S->S):VD<F, S> return switch [a1, a2]
  {
    case [Success(s1), Success(s2)]: Success(appendSuccess(s1,s2));
    case [Success(_),  Failure(f) ]: Failure(f);
    case [Failure(f),  Success(_) ]: Failure(f);
    case [Failure(f1), Failure(f2)]: Failure(appendFailure(f1, f2));
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
    case Failure(_): Scuts.error("Validation has no success value");
    case Success(s): s;
  }
  
  /**
   * Returns the right value of e or throws an error if it's a left Validation.
   */
  public static function extractFailure<F,S>(v:VD<F,S>):F return switch (v) 
  {
    case Failure(f): f;
    case Success(_): Scuts.error("Validation has no failure value");
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
   * Returns true if e is a success value.
   */
  public static function isSuccess<F,S>(v:VD<F,S>):Bool return switch (v) 
  {
    case Failure(_): false;
    case Success(_): true;
  }
  
 
  /**
   * Returns true if e is a failure value.
   */
  public static inline function isFailure<F,S>(e:VD<F,S>):Bool
  {
    return !isSuccess(e);
  }
  

  
  /**
   * Maps the right side of an Validation with f and flattens the result. 
   */
  public static inline function flatMap <F,S,SS> (o:VD<F,S>, f:S->VD<F, SS>):VD<F,SS> return switch o 
  {
    case Failure(f): Failure(f);
    case Success(v): f(v);
  }
  
  /**
   * Maps the left side of an Validation with f and flattens the result. 
   */
  public static function flatMapFailure < F,S,FF > (o:VD<F,S>, f:F->VD<FF, S>):VD<FF,S> return switch o
  {
    case Failure(v): f(v);
    case Success(s): Success(s); // avoids creating a new object
  }
  
  
  
  /**
   * Flattens the success value of an Validation.
   */
  public static function flatten <F,S> (v:VD<F, VD<F,S>>):VD<F,S> return switch v
  {
    case Failure(f): Failure(f);
    case Success(s): s;
  }
  
  /**
   * Flattens the failure value of an Validation.
   */
  public static function flattenFailure <F,S> (v:VD<VD<F,S>, S>):VD<F,S> return switch v 
  {
    case Failure(f): f;
    case Success(s): Success(s);
  }
  
  /**
   * Maps the success value of an Validation and returns a new Validation based on the mapping function f.
   */
  public static function map < F,S,SS > (v:VD<F,S>, f:S->SS):VD<F,SS> return switch v
  {
    case Failure(f): Failure(f);
    case Success(s): Success(f(s));
  }
  
  
  
  /**
   * Maps the left side of an Validation and returns a new Validation based on the mapping function f.
   * 
   */
  public static function mapFailure < F,S,FF > (v:VD<F,S>, f:F->FF):VD<FF,S> return switch v
  {
    case Failure(l): Failure(f(l));
    case Success(s): Success(s);
  }
  
  public static inline function fail <A,B>(v:VD<A,B>):FailProjection<A,B> return new FailProjection(v);
  
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
  
  public static function zipWith <F,S1,S2,S3>(v1:VD<F,S1>, v2:VD<F,S2>, f:S1->S2->S3):VD<F,S3> return switch [v1,v2]
  {
    case [Success(s1), Success(s2)] : Success(f(s1,s2));
    case [Failure(f), _] : Failure(f);
    case [_, Failure(f)] : Failure(f);
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




private typedef FP<F,S> = FailProjection<F,S>;

class FailProjectionExt 
{
  public static inline function validation <F,S>(v:FP<F,S>):VD<F,S> return cast v;
  
  public static inline function map <F,S,FF> (v:FP<F,S> , f:F->FF):FP<FF,S> 
  {
    return validation(v).mapFailure(f).fail();
  }
  
  public static inline function flatMap <F,S,FF> (v:FP<F,S> , f:F->VD<FF,S>):FP<FF,S> 
  {
    return validation(v).flatMapFailure(f).fail();
  }
  
  public static inline function flatten <F,S> (v:FP<VD<F,S>, S>):FP<F,S> 
  {
    return validation(v).flattenFailure().fail();
  }
  
  public static inline function isSuccess<F,S>(v:FP<F,S>):Bool
  {
    return validation(v).isSuccess();
  }
  
  public static inline function isFailure<F,S>(v:FP<F,S>):Bool
  {
    return validation(v).isFailure();
  }
  
  public static inline function option<F,S>(v:FP<F,S>):Option<F>
  {
    return validation(v).optionFailure();
  }
  
  public static inline function each < F,S> (v:FP< F,S> , f:F->Void):Void 
  {
    return validation(v).eachFailure(f);
  }
  
  public static inline function extract<F,S>(v:FP<F,S>):F 
  {
    return validation(v).extractFailure();
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