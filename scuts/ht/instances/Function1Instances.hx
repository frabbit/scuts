
package scuts.ht.instances;

import scuts.ht.classes.Functor;
import scuts.ht.classes.Semigroup;

class Function1Instances {

  @:implicit @:noUsing
  public static function semigroup<A,B>(semiB:Semigroup<B>):Semigroup<A->B> return new Function1Semigroup(semiB);

}


class Function1Semigroup<A,B> implements Semigroup <A->B>
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



class Function1_2Functor<A> implements Functor<A->In>
{
  public function new () {}

  public function map<R, R1>(g:A->R, f:R->R1):A->R1
  {
    var g1:A->R = g;
    return (function (x:A) return f(g1(x)));
  }
}



// Arrow of Functions

/*
class FunctionArrow extends ArrowAbstract<In->In>
{
  public function new (cat) super(cat);


  override public inline function arr <B,C>(f:B->C):FunctionOfOf<B, C>
  {
    return f;
  }

  override public function first <B,C,D>(f:FunctionOfOf<B,C>):FunctionOfOf<Tup2<B,D>, Tup2<C,D>>
  {
    return arr(function (t:Tup2<B,D>) return Tup2.create(f.unbox()(t._1), t._2));
  }

}

class FunctionCategory extends CategoryAbstract<In->In>
{

  public function new() {}

  override public function id <A>(a:A):FunctionOfOf<A, A>
  {
    return function (a) return a;
  }

  override public function dot <A,B,C>(f:FunctionOfOf<B, C>, g:FunctionOfOf<A, B>):FunctionOfOf<A, C>
  {
    return f.compose(g);
  }

}

class Function1Zero<A,B> implements Zero<A->B>
{
  var zeroB:Zero<B>;

  public function new (zeroB:Zero<B>)
  {
    this.zeroB = zeroB;
  }

  public inline function zero ():A->B
  {
    return function (a) return zeroB.zero();
  }
}
*/