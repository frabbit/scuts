package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.instances.ArrayTOfFunctor;
import hots.In;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

using hots.macros.Box;



class ArrayTOfApplicative<M> extends ApplicativeAbstract<Of<M,Array<In>>> {
  
  var appM:Applicative<M>;

  public function new (appM:Applicative<M>) 
  {
    super(ArrayTOfPointed.get(appM));
    this.appM = appM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(f:ArrayTOf<M,A->B>, val:ArrayTOf<M,A>):ArrayTOf<M,B> 
  {
    var f2 = appM.map(function (x:Array<A->B>) 
    {
      return function (a:Array<A>) {
        var res = [];
        for (a1 in a) {
          for (f1 in x) {
            res.push(f1(a1));
          }
        }
        return res;
      }
    }, f.unbox());
    
    return appM.apply(f2, val.unbox()).box();

  }

}
