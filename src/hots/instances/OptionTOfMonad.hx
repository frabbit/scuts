package hots.instances;

import hots.In;
import hots.Of;
import scuts.core.types.Option;

import scuts.core.extensions.OptionExt;
import hots.classes.Monad;
import hots.classes.MonadAbstract;


using scuts.core.extensions.Function1Ext;

private typedef B = OptionBox;
private typedef BT = OptionTBox;

class OptionTOfMonadImpl<M> extends MonadAbstract<Of<M, Option<In>>> {
  
  var monad:Monad<M>;
  
  public function new (monad:Monad<M>) {
    super(OptionTOfApplicative.get(monad));
    this.monad = monad;
  }
  
  override public function flatMap<A,B>(val:OptionTOf<M,A>, f: A->OptionTOf<M,B>):OptionTOf<M,B> 
  {
    var fmapped = monad.flatMap(BT.unbox(val), 
      function (a) {
        var mapped = OptionOfMonad.get().map(f, B.box(a));
        var unboxed = B.unbox(mapped);

        var res = switch (unboxed) {
          case Some(v): 
            var r = None;
            monad.map(function (x:Option<B>) r = x, BT.unbox(v));
            r;
            
          case None: None;
        }
        return monad.ret(res);//res;
      });
    return BT.box(fmapped);
  }
  
}

typedef OptionTOfMonad = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionTOfMonadImpl)]>;

