package scuts.ht.instances.std;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.ArrayTOf;
import scuts.core.Arrays;
import scuts.ht.classes.Functor;







class ArrayTApply<M> extends ApplyAbstract<Of<M,Array<In>>> {
  
  var appM:Apply<M>;
  var funcM:Functor<M>;

  public function new (appM, funcM, func) 
  {
    super(func);
    this.appM = appM;
    this.funcM = funcM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(of:ArrayTOf<M,A>, f:ArrayTOf<M,A->B>):ArrayTOf<M,B> 
  {
    function f1 (x:Array<A->B>) 
    {
      return function (a:Array<A>) return Arrays.zipWith(x,a, function (x1,a1) return x1(a1));
    }
    
    var newF = funcM.map(f, f1);
    
    return appM.apply(of, newF);
  }

}
