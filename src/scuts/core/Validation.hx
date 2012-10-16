package scuts.core;


enum Validation < F, S > {
  Failure(f:F);
  Success(s:S);
}

abstract FailProjection<F,S> {}

