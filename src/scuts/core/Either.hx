package scuts.core;

enum Either < L, R > {
  Left(l:L);
  Right(r:R);
}


// newtype wrapper for left projections
abstract LeftProjection<L,R> => Either<L,R> {}

// newtype wrapper for right projections
abstract RightProjection<L,R> => Either<L,R> {}
