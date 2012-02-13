package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.instances.ArrayOfTFunctor;
import hots.In;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

private typedef B = ArrayTBox;



class ArrayOfTApplicativeImpl<M> extends ApplicativeAbstract<Of<M,Array<In>>> {
  
  var appM:Applicative<M>;

  public function new (appM:Applicative<M>) 
  {
    var f = ArrayOfTFunctor.get(appM);
    super(f);
    this.appM = appM;
  }

  /**
   * aka return, pure
   */
  override public function ret<A>(x:A):ArrayOfT<M,A> {
    return B.box(appM.ret([x]));
  }
  /**
   * aka <*>
   */
  override public function apply<A,B>(f:ArrayOfT<M,A->B>, val:ArrayOfT<M,A>):ArrayOfT<M,B> {
    var f1:Of<M, Array<A->B>> = B.unbox(f);
    var val1:Of<M, Array<A>> = B.unbox(val);
    
    var f2 = appM.map(function (f:Array<A->B>) {
      return function (a:Array<A>) {
        var res = [];
        for (a1 in a) {
          for (f1 in f) {
            res.push(f1(a1));
          }
        }
        return res;
      }
    }, f1);
    
    return B.box(appM.apply(f2, val1));

  }

}

typedef ArrayOfTApplicative = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayOfTApplicativeImpl)]>;