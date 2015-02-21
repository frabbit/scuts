package scuts.ht.instances.std;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.ApplyAbstract;
using scuts.ht.instances.std.ArrayT;
import scuts.core.Arrays;
import scuts.ht.classes.Functor;







class ArrayTApply<M> extends ApplyAbstract<ArrayT<M,_>> {

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
  override public function apply<A,B>(of:ArrayT<M,A>, f:ArrayT<M,A->B>):ArrayT<M,B>
  {
    function f1 (x:Array<A->B>)
    {
      return function (a:Array<A>) return Arrays.zipWith(x,a, function (x1,a1) return x1(a1));
    }

    var newF = funcM.map(f.runT(), f1);

    return appM.apply(of.runT(), newF).arrayT();
  }

}
