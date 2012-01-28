package scuts.core.extensions;

import scuts.core.types.Option;
import scuts.core.types.Either;
import scuts.Scuts;

class Eithers 
{

  public static function left<A,B>(e:Either<A,B>):A 
  {
    return switch (e) {
      case Left(l): l;
      case Right(r): Scuts.error("Either has no left value");
    }
  }
  
  public static function right<A,B>(e:Either<A,B>):B 
  {
    return switch (e) {
      case Left(l): Scuts.error("Either has no right value");
      case Right(r): r;
    }
  }
  
  public static function leftOption<A,B>(e:Either<A,B>):Option<A> 
  {
    return switch (e) {
      case Left(l): Some(l);
      case Right(r): None;
    }
  }
  
  public static function rightOption<A,B>(e:Either<A,B>):Option<B>
  {
    return switch (e) {
      case Left(l): None;
      case Right(r): Some(r);
    }
  }
  
  public static function isLeft<A,B>(e:Either<A,B>):Bool
  {
    return switch (e) {
      case Left(l): true;
      case Right(r): false;
    }
  }
  
  public static function isRight<A,B>(e:Either<A,B>):Bool
  {
    return !isLeft(e);
  }
  
  public static function flatMap < A,B,C,D > (o:Either<A,B>, leftF:A->Either<C, D>, rightF:B->Either<C,D>):Either<C,D>
  {
    return switch (o) {
      case Left(v): leftF(v);
      case Right(v): rightF(v);
    }
  }
  
  public static function flatMapLeft < A,B,C,D > (o:Either<A,B>, leftF:A->Either<C, B>):Either<C,B>
  {
    return switch (o) {
      case Left(v): leftF(v);
      case Right(v): cast o;
    }
  }
  
  public static function flatMapRight < A,B,C,D > (o:Either<A,B>, rightF:B->Either<A, C>):Either<A,C>
  {
    return switch (o) {
      case Left(v): cast o;
      case Right(v): rightF(v);
    }
  }
  
   public static function mapLeft < A,B,C > (e:Either<A,B>, f:A->C):Either<C,B>
  {
    return switch (e) {
      case Left(l): Left(f(l));
      case Right(r): Right(r);
    }
  }
  
  public static function mapRight < A,B,C > (e:Either<A,B>, f:B->C):Either<A,C>
  {
    return switch (e) {
      case Left(l): Left(l);
      case Right(r): Right(f(r));
    }
  }
  
  public static function map < A,B,C,D > (o:Either<A,B>, left:A->C, right:B->D):Either<C,D>
  {
    return switch (o) {
      case Left(v): Left(left(v));
      case Right(v): Right(right(v));
    }
  }
  
}