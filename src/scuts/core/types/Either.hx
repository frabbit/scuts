package scuts.core.types;


enum Either < L, R > {
  Left(l:L);
  Right(r:R);
}


import scuts.core.types.Either.Either;
// newtype for left projections
@:native("scuts.core.types.Either")
extern class LeftProjection<L,R> {}

import scuts.core.types.Either.Either;
// newtype for right projections
@:native("scuts.core.types.Either")
extern class RightProjection<L,R> {}
