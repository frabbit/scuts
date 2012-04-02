package scuts.core.types;


enum Validation < F, S > {
  Failure(f:F);
  Success(s:S);
}
