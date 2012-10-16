package hots.instances;
import hots.classes.Applicative;
import hots.classes.Apply;
import hots.In;
import hots.Of;
import hots.of.ArrayTOf;
import scuts.core.Arrays;
import hots.classes.Functor;



using hots.box.ArrayBox;

using hots.ImplicitCasts;
using hots.Hots;
using hots.Identity;

class ArrayTApply<M> implements Apply<Of<M,Array<In>>> {
  
  var appM:Apply<M>;
  var funcM:Functor<M>;

  public function new (appM, funcM) 
  {
    this.appM = appM;
    this.funcM = funcM;
  }

  /**
   * aka <*>
   */
  public function apply<A,B>(f:ArrayTOf<M,A->B>, of:ArrayTOf<M,A>):ArrayTOf<M,B> 
  {
    function f1 (x:Array<A->B>) 
    {
      return function (a:Array<A>) return Arrays.zipWith(x,a, function (x1,a1) return x1(a1));
    }
    
    var newF = funcM.map(f.runT(), f1);
    
    return appM.apply(newF, of.runT()).intoT();
  }

}
