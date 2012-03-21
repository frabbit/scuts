package hots.instances;

import hots.In;
import hots.Of;
import scuts.core.types.Option;
using scuts.core.extensions.OptionExt;
import hots.classes.Monad;
import hots.classes.MonadAbstract;

using scuts.core.extensions.Function1Ext;

using hots.macros.Box;

class OptionTOfMonad<M> extends MonadAbstract<Of<M, Option<In>>> {
  
  var monadM:Monad<M>;
  
  public function new (monadM:Monad<M>) {
    super(OptionTOfApplicative.get(monadM));
    this.monadM = monadM;
    
  }
  
  override public function flatMap<A,B>(val:Of<Of<M, Option<In>>,A>, f: A->Of<Of<M, Option<In>>,B>):Of<Of<M, Option<In>>,B> 
  {
    return monadM.flatMap(val.unbox(), function (a)
    {
      return switch (a) 
      {
        case Some(v): f(v).unbox();
        case None: monadM.pure(None);
      }
    }).box();
  }
  
}

