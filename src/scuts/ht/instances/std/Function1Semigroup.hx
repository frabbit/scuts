package scuts.ht.instances.std;

import scuts.ht.classes.Semigroup;


class Function1Semigroup<A,B> implements Semigroup<A->B>
{
  var semigroupB:Semigroup<B>;
  
  public function new (semigroupB:Semigroup<B>) 
  {
    this.semigroupB = semigroupB;
  }
  
  public inline function append (a:A->B, b:A->B):A->B 
  {
    return function (x) return semigroupB.append(a(x), b(x));
  }
  
}
