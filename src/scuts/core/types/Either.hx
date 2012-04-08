package scuts.core.types;


enum Either < L, R > {
  Left(l:L);
  Right(r:R);
}

// newtype for left projections
@:native("scuts.core.types.Either")
extern class LeftProjection<L,R> {}

// newtype for right projections
@:native("scuts.core.types.Either")
extern class RightProjection<L,R> {}
