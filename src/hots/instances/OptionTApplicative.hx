package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import hots.of.OptionTOf;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

class OptionTApplicative<M> extends ApplicativeAbstract<Of<M,Option<In>>> 
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
  override public function apply<A,B>(f:OptionTOf<M,A->B>, val:OptionTOf<M,A>):OptionTOf<M,B> 
  {
    function f1 (f)
    {
      return function (a) return Options.zipWith(f,a, function (f1,a1) return f1(a1));
    }
    
    var newF = applicativeM.map(f.runT(), f1);
    
    return applicativeM.apply(newF, val.runT());
  }

}
