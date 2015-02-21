package scuts.ht.instances.std;


import scuts.ht.classes.Category;
import scuts.ht.classes.CategoryAbstract;
import scuts.ht.classes.Monad;
import scuts.ht.instances.std.Kleisli;



class KleisliCategory<M> extends CategoryAbstract<Kleisli<M,_,_>>
{
  private var m:Monad<M>;

  public function new (m:Monad<M>)
  {
    this.m = m;
  }

  override public function id <A>(a:A):Kleisli<M, A, A>
  {
    return new Kleisli(function (a) return m.pure(a));
  }
  /**
   * aka (.)
   */
  override public function dot <A,B,C>(f:Kleisli<M, B, C>, g:Kleisli<M, A, B>):Kleisli<M, A, C>
  {
    var f1 = f.run(); // b -> m c
    var g1 = g.run(); // a -> m b

    // h :: a -> m c
    var h = function (a:A) {
      var c = g1(a); // m b
      return m.flatMap(c, f1); // m c
    }
    return new Kleisli(h);
  }
}
