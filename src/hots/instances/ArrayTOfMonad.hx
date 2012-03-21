package hots.instances;
import hots.classes.MonadAbstract;
import hots.classes.Monad;
import hots.instances.ArrayTOfApplicative;

import hots.In;
import hots.Of;
import scuts.core.extensions.ArrayExt;

using hots.macros.Box;


class ArrayTOfMonad<M> extends MonadAbstract<Of<M,Array<In>>> {
  
  var monadM:Monad<M>;

  public function new (monadM:Monad<M>) 
  {
    super(ArrayTOfApplicative.get(monadM));
    this.monadM = monadM;
  }
  
  override public function flatMap<A,B>(val:ArrayTOf<M,A>, f: A->ArrayTOf<M,B>):ArrayTOf<M,B> 
  {
    return monadM.flatMap(val.unbox(), function (a:Array<A>):Of<M, Array<B>>
    {
      var res = [];
      for (e1 in a) 
      {
        monadM.map(
          function (x:Array<B>) for (e2 in x) res.push(e2), 
          f(e1).unbox()
        );
      }
      return monadM.pure(res);
    }).box();
  }
}
