package scuts.core;


typedef LazyList<T> = Void->LazyNode<T>;

enum LazyNode<T> {
  LazyNil;
  LazyCons(e:T, tail:LazyList<T>);

}