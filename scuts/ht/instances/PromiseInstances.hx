package scuts.ht.instances;

import scuts.ht.classes.Semigroup;
import scuts.ht.classes.Show;


import scuts.ht.classes.*;

using scuts.core.Promises;

class PromiseInstances {

  @:implicit @:noUsing
  public static var monadEmpty : MonadEmpty<Promise<In>> = new PromiseMonadEmpty();

  @:implicit @:noUsing
  public static function show <X>(showX:Show<X>) : Show<Promise<X>> return new PromiseShow(showX);

  @:implicit @:noUsing
  public static var monad : Monad<Promise<In>> = monadEmpty;

  @:implicit @:noUsing
  public static var functor : Functor<Promise<In>> = monadEmpty;

  @:implicit @:noUsing
  public static inline function monoid<X>(semiX:Semigroup<X>) : Monoid<Promise<X>> return new PromiseMonoid(semiX);

  @:implicit @:noUsing
  public static inline function semigroup<X>(semiX:Semigroup<X>) : Semigroup<Promise<X>> return monoid(semiX);
}


class PromiseMonadEmpty implements MonadEmpty<Promise<In>>
{
  public function new () {}

  public function map<A,B>(of:Promise<A>, f:A->B):Promise<B>
  {
    return Promises.map(of, f);
  }

  public function pure<A>(a:A):Promise<A>
  {
    return Promises.pure(a);
  }

  public function flatMap<A,B>(val:Promise<A>, f: A->Promise<B>):Promise<B>
  {
    return Promises.flatMap(val, f);
  }

  public function flatten<A>(val:Promise<Promise<A>>):Promise<A>
  {
    return Promises.flatten(val);
  }

  public inline function empty <A>():Promise<A>
  {
    return Promises.cancelled(scuts.core.Unit);
  }
}

class PromiseMonoid<X> implements Monoid<Promise<X>> {

  var semi:Semigroup<X>;

  public function new (semi:Semigroup<X>) this.semi = semi;

  public function append (a:Promise<X>, b:Promise<X>):Promise<X>
  {
    return a.zipWith(b, semi.append);

  }

  public inline function zero ():Promise<X>
  {
    return Promises.cancelled("error");
  }
}

class PromiseShow<T> implements Show<Promise<T>> {
  var showT:Show<T>;

  public function new (s:Show<T>) {
    this.showT = s;
  }
  public function show (p:Promise<T>)
  {
    return switch (p.extract())
    {
      case Success(x): "Promise(Success(" + showT.show(x) + "))";
      case Failure(f): "Promise(Failure(" + Std.string(f) + "))";
    }
  }
}

