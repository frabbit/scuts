package scuts.data;

enum List<T> {
  Nil;
  Cons(e:T, tail:List<T>);
}
