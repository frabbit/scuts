package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import hots.of.PromiseTOf;
import scuts.core.types.Promise;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

using scuts.core.extensions.Promises;

class PromiseTApplicative<M> extends ApplicativeAbstract<Of<M,Promise<In>>> 
{
  var applicativeM:Applicative<M>;

  public function new (applicativeM:Applicative<M>, pure, functor) 
  {
    super(pure, functor);
    this.applicativeM = applicativeM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(f:PromiseTOf<M,A->B>, val:PromiseTOf<M,A>):PromiseTOf<M,B> 
  {
    function f1 (f:Promise<A->B>):Promise<A>->Promise<B>
    {
      return function (a) return f.zipWith(a, function (f1, a1) return f1(a1));
    }
    
    var newF = applicativeM.map(f.runT(), f1);
    
    return applicativeM.apply(newF, val.runT());
  }

}
