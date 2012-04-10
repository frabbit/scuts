package hots.instances;
import hots.classes.MonadTransAbstract;
import hots.In;
import hots.Of;
import hots.classes.Monad;

import scuts.core.types.Option;

private typedef B = hots.box.OptionBox;


class OptionOfMonadTrans<M> extends MonadTransAbstract<Option<In>> {
  
  public function new () {}

  override public function lift <M, A>(of:Of<M, A>, monad:Monad<M>):OptionTOf<M,A>
  {
    return B.boxT(monad.map(of, function (x) return Some(x)));
  }
}
