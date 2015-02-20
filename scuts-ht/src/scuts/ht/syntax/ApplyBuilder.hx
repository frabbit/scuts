package scuts.ht.syntax;
import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.classes.Bind;
import scuts.ht.classes.Functor;

/**
 * ...
 * @author
 */

class ApplyBuilder
{

  public static function createFromFunctorAndBind<X>(f:Functor<X>, b:Bind<X>):Apply<X>
  {
    return new FunctorBindApply(f, b);
  }

}

class FunctorBindApply<X> extends ApplyAbstract<X> implements Apply<X>{

  private var b:Bind<X>;

  public function new (t:Functor<X>, b:Bind<X>)
  {
    super(t);

    this.b = b;
  }

  override public function apply<A,B>(a:X<A>, f:X<A->B>):X<B> {

    function z (g:A->B) return map(a, function (x) return g(x));
    return b.flatMap( f, z);
  }
}

