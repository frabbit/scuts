package scuts1.instances.std;
import scuts1.classes.Applicative;
import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.core.Of;
import scuts1.instances.std.ArrayTOf;
import scuts.core.Arrays;
import scuts1.classes.Functor;







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
    
    var newF = funcM.map(f, f1);
    
    return appM.apply(newF, of);
  }

}
