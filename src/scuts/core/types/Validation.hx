package scuts.core.types;


enum Validation < F, S > {
  Failure(f:F);
  Success(s:S);
}

// newtype for fail projections
@:native("scuts.core.types.Validation")
extern class FailProjection<F,S> {}
