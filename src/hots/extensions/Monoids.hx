package hots.extensions;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.classes.Zero;
import hots.extensions.Semigroups;

class Monoids 
{
  public static function append <T>(v1:T, v2:T, m:Semigroup<T>):T return m.append(v1, v2)
  
  /**
   * Helper Function to create various Monoid instances from two Functions
   */
  public static inline function create<T>(append:T->T->T, zero:Void->T) return new MonoidByFun(append, zero)
  
  public static inline function createFromSemiAndZero<T>(semi:Semigroup<T>, zero:Zero<T>) return new MonoidDefault(semi, zero)
}


class MonoidByFun<T> extends SemigroupByFun<T>, implements Monoid<T>
{
  var _zero  : Void->T;
  
  public function new (append:T->T->T, zero:Void->T) {
    super(append);
    _zero = zero;
  }
  
  public inline function zero () return _zero()  
}


import scuts.Scuts;



class MonoidDefault<A> implements Monoid<A>
{
  var semi:Semigroup<A>;
  var _zero:Zero<A>;
  
  public function new (semi:Semigroup<A>, zero:Zero<A>) 
  {
    this.semi = semi;
    this._zero = zero;
  }
  
  /**
   * @see <a href="Monoid.html">hots.classes.Monoid</a>
   */
  public function zero ():A  return _zero.zero()
  
  // delegation Semigroup
  
  /**
   * @see <a href="Semigroup.html">hots.classes.Semigroup</a>
   */
  public inline function append (a1:A, a2:A):A return semi.append(a1,a2)
  
}

