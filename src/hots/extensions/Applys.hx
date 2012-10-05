package hots.extensions;
import hots.classes.Apply;
import hots.classes.Bind;
import hots.classes.Functor;
import hots.Of;

/**
 * ...
 * @author 
 */

class Applys 
{

  public static function createFromFunctorAndBind<X>(f:Functor<X>, b:Bind<X>):Apply<X> 
  {
    return new FunctorBindApply(f, b);
  }
  
}

class FunctorBindApply<X> implements Apply<X>{
  private var t:Functor<X>;
  private var b:Bind<X>;
    
  public function new (t:Functor<X>, b:Bind<X>)
  {
    this.t = t;
    this.b = b;
  }
  
  public function apply<A,B>(f:Of<X,A->B>, a:Of<X,A>):Of<X,B> {
    
    function z (g:A->B) return t.map(a, function (x) return g(x));
    return b.flatMap( f, z);
  }
}

