package scuts.ht.instances.std;


import scuts.ht.classes.Semigroup;



class Function0Semigroup<A> implements Semigroup<Void->A>
{
  var semigroupA:Semigroup<A>;
  
  public function new (semigroupA:Semigroup<A>) 
  {
    this.semigroupA = semigroupA;
  }
  
  public inline function append (f1:Void->A, f2:Void->A):Void->A 
  {
    return function () return semigroupA.append(f1(), f2());
  }
  
}
