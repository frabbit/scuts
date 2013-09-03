package scuts.ht.syntax;
import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.classes.Bind;
import scuts.ht.classes.Functor;
import scuts.ht.core.Of;

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
  
  override public function apply<A,B>(a:Of<X,A>, f:Of<X,A->B>):Of<X,B> {
    
    function z (g:A->B) return map(a, function (x) return g(x));
    return b.flatMap( f, z);
  }
}

