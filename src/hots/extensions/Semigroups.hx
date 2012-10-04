package hots.extensions;

import hots.classes.Semigroup;


class Semigroups 
{
  public static function append <T>(v1:T, v2:T, m:Semigroup<T>):T 
  {
    return m.append(v1, v2);
  }
  
  public static inline function create<T>(append:T->T->T) return new SemigroupByFun(append)
  
}


class SemigroupByFun<T> implements Semigroup<T>
{
  var _append : T->T->T;
  
  public function new (append:T->T->T) {
    _append = append;
  }

  public inline function append (a:T,b:T) return _append(a,b)
  
}