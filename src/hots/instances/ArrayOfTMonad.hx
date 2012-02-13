package hots.instances;
import hots.classes.Applicative;
import hots.classes.MonadAbstract;
import hots.classes.FunctorAbstract;
import hots.classes.Monad;
import hots.instances.ArrayOfTApplicative;

import hots.In;
import hots.Of;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

private typedef BT = ArrayTBox;
private typedef B = ArrayBox;

using hots.extensions.MonadExt;

class ArrayOfTMonadImpl<M> extends MonadAbstract<Of<M,Array<In>>> {
  
  var monadM:Monad<M>;

  public function new (monadM:Monad<M>) 
  {
    super(ArrayOfTApplicative.get(monadM));
    this.monadM = monadM;
  }

  override public function flatMap<A,B>(val:ArrayOfT<M,A>, f: A->ArrayOfT<M,B>):ArrayOfT<M,B> 
  {
    var fmapped = monadM.flatMap(BT.unbox(val), 
      function (a) {
        var mapped = ArrayOfFunctor.get().map(f, B.box(a));
        var unboxed = B.unbox(mapped);
        
        var res = [];
        for (e in unboxed) {
          monadM.map(function (x:Array<B>) {
            for (a in x) {
              res.push(a);
            }
          },BT.unbox(e));
        }
        return monadM.ret(res);//res;
      });
    return BT.box(fmapped);
  }
  

  
}

typedef ArrayOfTMonad = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayOfTMonadImpl)]>;