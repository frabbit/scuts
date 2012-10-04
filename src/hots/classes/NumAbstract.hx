package hots.classes;
import hots.classes.Eq;
import hots.classes.Show;
import scuts.Scuts;




class NumAbstract<T> implements Num<T> 
{
  var eqT:Eq<T>;
  var showT:Show<T>;
    
  public function new (eqT:Eq<T>, showT:Show<T>) {
    this.eqT = eqT;
    this.showT = showT;
  }
  
  /**
   * @see <a href="Num.html">hots.classes.Num</a>
   */
  public function minus (a:T, b:T):T return minus(a, negate(b))
  
  // abstract
  
  /**
   * @see <a href="Num.html">hots.classes.Num</a>
   */
  public function plus (a:T, b:T):T return Scuts.abstractMethod()
  /**
   * @see <a href="Num.html">hots.classes.Num</a>
   */
  public function mul (a:T, b:T):T return Scuts.abstractMethod()
  
  /**
   * @see <a href="Num.html">hots.classes.Num</a>
   */
  public function negate (a:T):T return Scuts.abstractMethod()
  /**
   * @see <a href="Num.html">hots.classes.Num</a>
   */
  public function abs (a:T):T return Scuts.abstractMethod()
  /**
   * @see <a href="Num.html">hots.classes.Num</a>
   */
  public function signum (a:T):T return Scuts.abstractMethod()
  /**
   * @see <a href="Num.html">hots.classes.Num</a>
   */
  public function fromInt (a:Int):T return Scuts.abstractMethod()
  
  
  // delegation of Show
  /**
   * @see <a href="Show.html">hots.classes.Show</a>
   */
  public inline function show (a:T):String return showT.show(a)
  
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