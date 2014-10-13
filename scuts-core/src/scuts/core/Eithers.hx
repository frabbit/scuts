package scuts.core;

import scuts.core.Options;

import scuts.Scuts;
import scuts.core.Validations;


using scuts.core.Eithers;

enum Either < L, R > {
  Left(l:L);
  Right(r:R);
}

// newtype wrapper for left projections
abstract LeftProjection<L,R>(Either<L,R>) to Either<L,R> {

  public function new (e:Either<L,R>) {
    this = e;
  }



}




private typedef LP<L,R> = LeftProjection<L,R>;




class EitherConvert
{
  /**
   * Converts v into an Either, based on the nulliness of v.
   * If v is null, right is used as the Right value for the resulting Either.
   */
  public static inline function nullToEither < A,B > (v:Null<B>, left:A):Either<A,B>
  {
    return v == null ? Left(left) : Right(v);
  }

  /**
   * Converts v into a left Either.
   */
  public static inline function toLeft < L,R > (l:L):Either<L,R> return Left(l);

  /**
   * Converts v into a right Either.
   */
  public static inline function toRight < L,R > (r:R):Either<L,R> return Right(r);
}

class Eithers
{
  public static function append <L,R> (a1:Either<L,R>, a2:Either<L, R>, appendLeft:L->L->L, appendRight:R->R->R):Either<L, R> return switch (a1)
  {
    case Right(r1): switch (a2)
    {
      case Right(r2): Right(appendRight(r1,r2));
      case Left(l): Left(l);
    }
    case Left(l1): switch (a2)
    {
      case Right(_): Left(l1);
      case Left(l2): Left(appendLeft(l1, l2));
    }
  }

  public static function eq <A,B>(a:Either<A,B>, b:Either<A,B>, eqA:A->A->Bool, eqB:B->B->Bool):Bool return switch (a)
  {




    case Left(l1): switch (b)
    {
      case Left(l2): eqA(l1, l2);
      case Right(_): false;
    }
    case Right(r1): switch (b)
    {
      case Left(_): false;
      case Right(r2): eqB(r1, r2);
    }
  }

  public static function applyLeft <L,R,LL>(e:Either<L,R>, f:Either<L->LL, R>):Either<LL, R> return switch (f)
  {
    case Left(l1): switch (e)
    {
      case Left(l2): Left(l1(l2));
      case Right(r): Right(r);
    }
    case Right(r1): switch (e)
    {
      case Left(_): Right(r1);
      case Right(r2): Right(r2);
    }
  }

  public static function applyRight <L,R,RR>(e:Either<L,R>, f:Either<L, R->RR>):Either<L, RR> return switch [f,e]
  {
    case [Left(_),  Left(l)] | [Left(l),  _] | [_, Left(l)  ]: Left(l);
    case [Right(r1), Right(r2)]: Right(r1(r2));
    case _ : throw "assert";

  }

  public static function bool<L,R>(e:Either<L,R>):Bool return switch (e)
  {
    case Left(_): false;
    case Right(_):true;
  }

  public static function getOrElse<L,R>(e:Either<L,R>, handler:L->R):R return switch (e)
  {
    case Left(l): handler(l);
    case Right(r): r;
  }

  public static function orElse<L,R>(e:Either<L,R>, left:Void->Either<L,R>):Either<L,R> return switch (e)
  {
    case Left(_): left();
    case Right(_): e;
  }

  /**
   * Returns the left value of e or throws an error if it's a right Either.
   *
   * @param e Either Instance
   * @return the left Side of e
   */
  public static function extractLeft<L,R>(e:Either<L,R>):L return switch (e)
  {
    case Left(l): l;
    case Right(_): Scuts.error("Either has no Left value");
  }

  /**
   * Returns the right value of e or throws an error if it's a left Either.
   */
  public static function extractRight<L,R>(e:Either<L,R>):R return switch (e)
  {
    case Left(_): Scuts.error("Either has no Right value");
    case Right(r): r;
  }

  /**
   * Converts the left value of e into an Option.
   */
  public static function optionLeft<L,R>(e:Either<L,R>):Option<L> return switch (e)
  {
    case Left(l): Some(l);
    case Right(_): None;
  }

  public static function ifLeft<L,R,LL>(e:Either<L,R>, f:Void->Either<LL,R>):Either<LL,R> return switch (e)
  {
    case Left(_): f();
    case Right(r): Right(r);
  }

  public static function ifRight<L,R,RR>(e:Either<L,R>, f:Void->Either<L,RR>):Either<L,RR> return switch (e)
  {
    case Left(l): Left(l);
    case Right(_): f();
  }


  /**
   * Converts the right value of e into an Option.
   */
  public static function optionRight<L,R>(e:Either<L,R>):Option<R> return switch (e)
  {
    case Left(_): None;
    case Right(r): Some(r);
  }



  /**
   * Returns true if e is Left Either.
   */
  public static function isLeft<L,R>(e:Either<L,R>):Bool return switch (e)
  {
    case Left(_): true;
    case Right(_): false;
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
  public static function flatMap < L,R,LL,RR > (e:Either<L,R>, fl:L->Either<LL, RR>, fr:R->Either<LL,RR>):Either<LL,RR> return switch (e)
  {
    case Left(l): fl(l);
    case Right(r): fr(r);
  }



  /**
   * Maps the left side of an Either with the function leftF and flattens the result.
   *
   * @param e Either instance to flatMap
   * @param leftF the Mapping function
   *
   * @return flatMapped Either instance
   */
  public static function flatMapLeft < L,R,LL > (e:Either<L,R>, f:L->Either<LL, R>):Either<LL,R> return switch (e)
  {
    case Left(l): f(l);
    case Right(r): Right(r);
  }


  /**
   * Maps the right side of an Either with the function rightF and flattens the result.
   *
   * @param e Either instance to flatMap
   * @param rightF the Mapping function
   *
   * @return flatMapped Either instance
   */
  public static function flatMapRight < L,R,RR > (e:Either<L,R>, f:R->Either<L, RR>):Either<L,RR> return switch (e)
  {
    case Left(l): Left(l);
    case Right(r): f(r);
  }


  /**
   * Flattens both sides of an Either.
   *
   * @param e Either instance to flatten
   *
   * @return flattened Either instance
   */
  public static function flatten <L,R> (e:Either<Either<L,R>, Either<L,R>>):Either<L,R> return switch (e)
  {
    case Left(l): l;
    case Right(r): r;
  }

  /**
   * Flattens the left side of an Either.
   *
   * @param e Either instance to flatten
   *
   * @return flattened Either instance
   */
  public static function flattenLeft <L,R> (e:Either<Either<L,R>, R>):Either<L,R> return switch (e)
  {
    case Left(l): l;
    case Right(r): Right(r);
  }

  /**
   * Flattens the right side of an Either.
   *
   * @param e Either instance to flatten
   *
   * @return flattened Either instance
   */
  public static function flattenRight <L,R> (e:Either<L, Either<L,R>>):Either<L,R> return switch (e)
  {
    case Left(l): Left(l);
    case Right(r): r;
  }

  /**
   * Maps the left side of an Either and returns a new Either based on the mapping function f.
   *
   * @param e Either instance to map
   * @param f the mapping function if e is Left
   *
   * @return mapped Either instance
   */
  public static function mapLeft < L,R,LL > (e:Either<L,R>, f:L->LL):Either<LL,R> return switch (e)
  {
    case Left(l): Left(f(l));
    case Right(r): Right(r);
  }

  /**
   * Maps the right side of an Either and returns a new Either based on the mapping function f.
   *
   * @param e Either instance to map
   * @param f the mapping function if e is Right
   *
   * @return mapped Either instance
   */
  public static function mapRight < L,R,RR > (e:Either<L,R>, f:R->RR):Either<L,RR> return switch (e)
  {
    case Left(l): Left(l);
    case Right(r): Right(f(r));
  }

  /**
   * Maps an Either into a new one based on the mapping functions left and right.
   *
   * @param left the mapping function if e is Left
   * @param right the mapping function if e is Right
   *
   * @return mapped Either instance
   */
  public static function map < L,R,LL,RR > (e:Either<L,R>, left:L->LL, right:R->RR):Either<LL,RR> return switch (e)
  {
    case Left(l): Left(left(l));
    case Right(r): Right(right(r));
  }


  public static inline function leftProjection <L,R>(e:Either<L,R>):LeftProjection<L,R> return new LeftProjection(e);
}

class LeftProjections
{


  static inline function eitherF<L,R,LL>(e:L->LP<LL,R>):L->Either<LL,R> return e;

  static function either<L,R>(e:LP<L,R>):Either<L,R> return e;

  public static inline function flatMap < L,R,LL > (e:LP<L,R>, f:L->LP<LL, R>):LP<LL,R>
  {
    return either(e).flatMapLeft(eitherF(f)).leftProjection();
  }

  public static inline function map <L,R,LL> (e:LP<L,R>, f:L->LL) : LP<LL,R>
  {
    return either(e).mapLeft(f).leftProjection();
  }

  public static function apply <L,R,LL>(e:LP<L,R>, f:LP<L->LL, R>):LP<LL, R>
  {
    return either(e).applyLeft(either(f)).leftProjection();
  }
}
