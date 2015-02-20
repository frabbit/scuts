package scuts.ht.instances.std;

import scuts.ht.classes.Arrow;
import scuts.ht.classes.ArrowAbstract;
import scuts.ht.classes.Monad;

import scuts.ht.instances.std.KleisliCategory;

import scuts.ht.instances.std.Kleisli;

import scuts.core.Tuples;
import scuts.Scuts;

using scuts.core.Functions;



class KleisliArrow<M> extends ArrowAbstract<Kleisli<M,In,In>>
{
  var m:Monad<M>;

  public function new (m:Monad<M>, cat)
  {
    super(cat);
    this.m = m;
  }

  override public function arr <B,C>(f:B->C):Kleisli<M,B, C>
  {
    return new Kleisli(m.pure.compose(f));
  }

  override public function first <B,C,D>(f:Kleisli<M,B,C>):Kleisli<M, Tup2<B,D>, Tup2<C,D>>
  {
    return new Kleisli(function (t:Tup2<B,D>)
    {
      return m.flatMap(m.pure(t), function (t)
      {
        var d = f(t._1);
        return m.map(d, function (c) return Tup2.create(c,t._2));
      });
    });
  }
}
