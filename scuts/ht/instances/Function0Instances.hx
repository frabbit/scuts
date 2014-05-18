
package scuts.ht.instances;

import scuts.ht.classes.Semigroup;

class Function0Instances {

  @:implicit @:noUsing
  public static function semigroup<A>(semiA:Semigroup<A>):Semigroup<Void->A> return new Function0Semigroup(semiA);

}

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


/*
class Function0Zero<A> implements Zero<Void->A>
{

  var zeroA:Zero<A>;

  public function new (zeroA:Zero<A>) {

    this.zeroA = zeroA;
  }

  public inline function zero ():Void->A
  {
    return zeroA.zero;
  }
}

*/