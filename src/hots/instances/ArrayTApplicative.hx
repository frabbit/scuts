package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.of.ArrayTOf;
import scuts.core.extensions.Arrays;
import hots.classes.Functor;



using hots.box.ArrayBox;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

class ArrayTApplicative<M> extends ApplicativeAbstract<Of<M,Array<In>>> {
  
  var appM:Applicative<M>;

  public function new (appM, pure, func) 
  {
    super(pure, func);
    this.appM = appM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(f:ArrayTOf<M,A->B>, of:ArrayTOf<M,A>):ArrayTOf<M,B> 
  {
    function f1 (x:Array<A->B>) 
    {
      return function (a:Array<A>) return Arrays.zipWith(x,a, function (x1,a1) return x1(a1));
    }
    
    var newF = appM.map(f.runT(), f1);
    
    return appM.apply(newF, of.runT()).intoT();
  }

}
