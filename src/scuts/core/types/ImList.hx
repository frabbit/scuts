package scuts.core.types;

/**
 * An immutable List.
 */
enum ImList<T> {
  Nil;
  Cons(e:T, tail:ImList<T>);
}