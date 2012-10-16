package hots.classes;


import scuts.core.Ordering;

class OrdAbstract<T> implements Ord<T> {
  
  var eqT:Eq<T>;
  
  public function new (eqT:Eq<T>) {
    this.eqT = eqT;
  }
  /**
   * @see <a href="Ord.html">hots.classes.Ord</a>
   */
  public function compare (a:T, b:T):Ordering 
  {
    return if      (eqT.eq(a, b))       Ordering.EQ
           else if (lessOrEq(a, b))   Ordering.LT
           else                       Ordering.GT;
  }
  /**
   * @see <a href="Ord.html">hots.classes.Ord</a>
   */
  public function compareInt (a:T, b:T):Int 
  {
    return if      (eqT.eq(a, b))  0
           else if (lessOrEq(a, b))   -1
           else                       1;
  }
  /**
   * @see <a href="Ord.html">hots.classes.Ord</a>
   */
  public function less (a:T, b:T):Bool 
  {
    return compare(a, b) == LT;
  }
  /**
   * @see <a href="Ord.html">hots.classes.Ord</a>
   */
  public function lessOrEq (a:T, b:T):Bool 
  {
    return compare(a, b) != GT;
  }
  /**
   * @see <a href="Ord.html">hots.classes.Ord</a>
   */
  public function greaterOrEq (a:T, b:T):Bool 
  {
    return compare(a, b) != LT;
  }
  /**
   * @see <a href="Ord.html">hots.classes.Ord</a>
   */
  public function greater (a:T, b:T):Bool 
  {
    return compare(a, b) == GT;
  }
  /**
   * @see <a href="Ord.html">hots.classes.Ord</a>
   */
  public function min (a:T, b:T):T 
  {
    return lessOrEq(a, b) ? a : b;
  }
  /**
   * @see <a href="Ord.html">hots.classes.Ord</a>
   */
  public function max (a:T, b:T):T 
  {
    return greaterOrEq(a, b) ? a : b;
  }
  
  // delegation of Eq
  
  /**
   * @see <a href="Eq.html">hots.classes.Eq</a>
   */
  public inline function eq (a:T, b:T):Bool return eqT.eq(a,b)
  
  /**
   * @see <a href="Eq.html">hots.classes.Eq</a>
   */
  public inline function notEq (a:T, b:T):Bool return eqT.notEq(a,b)
}
