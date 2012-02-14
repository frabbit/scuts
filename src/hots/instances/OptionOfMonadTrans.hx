package hots.instances;
import hots.classes.MonadTransAbstract;
import hots.In;
import hots.Of;
import hots.classes.Monad;

import scuts.core.types.Option;


using scuts.core.extensions.Function1Ext;

private typedef BT = OptionTBox;
private typedef B = OptionBox;


class OptionOfMonadTransImpl<M> extends MonadTransAbstract<Option<In>> {
  
  public function new () {}

  override public function lift <M, A>(val:Of<M, A>, monad:Monad<M>):OptionOfT<M,A>
  {
    return BT.box(monad.map(function (x) return Some(x), val));
  }
}

typedef OptionOfMonadTrans = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionOfMonadTransImpl)]>;