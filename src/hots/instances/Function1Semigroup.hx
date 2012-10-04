package hots.instances;

import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;


class Function1Semigroup<A,B> extends SemigroupAbstract<A->B>
{
  var semigroupB:Semigroup<B>;
  
  public function new (semigroupB:Semigroup<B>) 
  {
    this.semigroupB = semigroupB;
  }
  
  override public inline function append (a:A->B, b:A->B):A->B 
  {
    return function (x) return semigroupB.append(a(x), b(x));
  }
  
}
