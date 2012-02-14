package hots.instances;

import hots.classes.MonadTransAbstract;
import hots.classes.Monad;
import hots.In;
import hots.Of;

using scuts.core.extensions.Function1Ext;

private typedef BT = ArrayTBox;
private typedef B = ArrayBox;


class ArrayOfMonadTransImpl<M> extends MonadTransAbstract<Array<In>> {
  
  public function new () {}

  override public function lift <M, A>(val:Of<M, A>, monad:Monad<M>):ArrayOfT<M,A>
  {
    return BT.box(monad.map(function (x) return [x], val));
  }
}

typedef ArrayOfMonadTrans = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayOfMonadTransImpl)]>;