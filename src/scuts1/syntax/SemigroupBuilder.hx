package scuts1.syntax;

import scuts1.classes.Semigroup;


class SemigroupsBuilder
{

  public static inline function create<T>(append:T->T->T) return new SemigroupByFun(append);
  
}


class SemigroupByFun<T> implements Semigroup<T>
{
  var _append : T->T->T;
  
  public function new (append:T->T->T) {
    _append = append;
  }

  public inline function append (a:T,b:T) return _append(a,b);
  
}