package hots.instances;

import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;


class Function0Semigroup<A> extends SemigroupAbstract<Void->A>
{
  var semigroupA:Semigroup<A>;
  
  public function new (semigroupA:Semigroup<A>) 
  {
    this.semigroupA = semigroupA;
  }
  
  override public inline function append (f1:Void->A, f2:Void->A):Void->A 
  {
    return function () return semigroupA.append(f1(), f2());
  }
  
}
