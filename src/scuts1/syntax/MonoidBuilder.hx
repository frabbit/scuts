package scuts1.syntax;
import scuts1.classes.Monoid;
import scuts1.classes.Semigroup;
import scuts1.classes.Zero;
import scuts1.syntax.SemigroupBuilder.SemigroupByFun;
import scuts1.syntax.Semigroups;
import scuts.Scuts;

class MonoidBuilder
{
  
  public static inline function create<T>(append:T->T->T, zero:Void->T) return new MonoidByFun(append, zero);
  
  public static inline function createFromSemiAndZero<T>(semi:Semigroup<T>, zero:Zero<T>) return new MonoidDefault(semi, zero);
}


class MonoidByFun<T> extends SemigroupByFun<T> implements Monoid<T>
{
  var _zero  : Void->T;
  
  public function new (append:T->T->T, zero:Void->T) {
    super(append);
    _zero = zero;
  }
  
  public inline function zero () return _zero();
}






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
   * @see <a href="Monoid.html">scuts1.classes.Monoid</a>
   */
  public function zero ():A  return _zero.zero();
  
  // delegation Semigroup
  
  /**
   * @see <a href="Semigroup.html">scuts1.classes.Semigroup</a>
   */
  public inline function append (a1:A, a2:A):A return semi.append(a1,a2);
  
}

