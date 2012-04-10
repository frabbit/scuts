package hots.instances;

import hots.classes.MonadTransAbstract;
import hots.classes.Monad;
import hots.In;
import hots.Of;



using hots.box.ArrayBox;


class ArrayOfMonadTrans<M> extends MonadTransAbstract<Array<In>> {
  
  public function new () {}

  override public function lift <M, A>(of:Of<M, A>, monad:Monad<M>):ArrayTOf<M,A>
  {
    return monad.map(of, function (x) return [x]).boxT();
  }
}
