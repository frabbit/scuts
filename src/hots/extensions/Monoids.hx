package hots.extensions;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.Implicit;


class Monoids 
{
  public static function append <T>(v1:T, v2:T, m:Implicit<Semigroup<T>>):T 
  {
    return m.append(v1, v2);
  }
  
  public static inline function create<T>(append:T->T->T, empty:Void->T) return new MonoidByFun(append, empty)
  
}


class MonoidByFun<T> implements Monoid<T>
{
  
  var append : T->T->T;
  var empty  : Void->T;
  
  
  public function new (append:T->T->T, empty:Void->T) {
    this.append = append;
    this.empty = empty;
  }
  
  public inline function empty (s:T) return empty()
  public inline function append (a:T,b:T) return append(a,b)
  
}