package hots.instances;
import hots.classes.MonadTransAbstract;
import hots.In;
import hots.Of;
import hots.classes.Monad;

import scuts.core.types.Option;

private typedef B = hots.macros.Box;


class OptionOfMonadTrans<M> extends MonadTransAbstract<Option<In>> {
  
  public function new () {}

  override public function lift <M, A>(val:Of<M, A>, monad:Monad<M>):OptionTOf<M,A>
  {
    return B.box(monad.map(function (x) return Some(x), val));
  }
}
