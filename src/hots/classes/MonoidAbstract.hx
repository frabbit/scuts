package hots.classes;
import scuts.Scuts;



class MonoidAbstract<A> implements Monoid<A>
{
  var semi:Semigroup<A>;
  
  public function new (semi:Semigroup<A>) 
  {
    this.semi = semi;
  }
  
  /**
   * @see <a href="Monoid.html">hots.classes.Monoid</a>
   */
  public function empty ():A  return Scuts.abstractMethod()
  
  // delegation Semigroup
  
  /**
   * @see <a href="Semigroup.html">hots.classes.Semigroup</a>
   */
  public inline function append (a1:A, a2:A):A return semi.append(a1,a2)
  
}

