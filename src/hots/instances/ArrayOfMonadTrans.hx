package hots.instances;

import hots.classes.MonadTransAbstract;
import hots.classes.Monad;
import hots.In;
import hots.Of;

using scuts.core.extensions.Function1Ext;

private typedef B = hots.macros.Box;


class ArrayOfMonadTrans<M> extends MonadTransAbstract<Array<In>> {
  
  public function new () {}

  override public function lift <M, A>(val:Of<M, A>, monad:Monad<M>):ArrayTOf<M,A>
  {
    return B.box(monad.map(function (x) return [x], val));
  }
}
