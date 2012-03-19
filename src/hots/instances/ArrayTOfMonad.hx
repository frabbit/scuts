package hots.instances;
import hots.classes.Applicative;
import hots.classes.MonadAbstract;
import hots.classes.FunctorAbstract;
import hots.classes.Monad;
import hots.instances.ArrayTOfApplicative;

import hots.In;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

private typedef B = hots.macros.Box;

using hots.extensions.MonadExt;

class ArrayTOfMonad<M> extends MonadAbstract<Of<M,Array<In>>> {
  
  var monadM:Monad<M>;

  public function new (monadM:Monad<M>) 
  {
    super(ArrayTOfApplicative.get(monadM));
    this.monadM = monadM;
  }

  override public function flatMap<A,B>(val:ArrayTOf<M,A>, f: A->ArrayTOf<M,B>):ArrayTOf<M,B> 
  {
    var fmapped = monadM.flatMap(B.unbox(val), 
      function (a) {
        var mapped = ArrayOfFunctor.get().map(f, B.box(a));
        var unboxed = B.unbox(mapped);
        
        var res = [];
        for (e in unboxed) {
          monadM.map(function (x:Array<B>) {
            for (a in x) {
              res.push(a);
            }
          },B.unbox(e));
        }
        return monadM.pure(res);//res;
      });
    return B.box(fmapped);
  }
}
