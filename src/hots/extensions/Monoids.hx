package hots.extensions;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.extensions.Semigroups;

class Monoids 
{
  public static function append <T>(v1:T, v2:T, m:Semigroup<T>):T return m.append(v1, v2)
  
  /**
   * Helper Function to create various Monoid instances from two Functions
   */
  public static inline function create<T>(append:T->T->T, empty:Void->T) return new MonoidByFun(append, empty)
}


class MonoidByFun<T> extends SemigroupByFun<T>, implements Monoid<T>
{
  var _empty  : Void->T;
  
  public function new (append:T->T->T, empty:Void->T) {
    super(append);
    _empty = empty;
  }
  
  public inline function empty () return _empty()  
}