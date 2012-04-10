package hots.classes;
import scuts.Scuts;



@:tcAbstract class MonoidAbstract<A> implements Monoid<A>
{
  var semi:Semigroup<A>;
  
  public function new (semi:Semigroup<A>) {
    this.semi = semi;
  }
  
  public inline function append (a1:A, a2:A):A return semi.append(a1,a2)
  public function empty ():A  return Scuts.abstractMethod()
  
}

