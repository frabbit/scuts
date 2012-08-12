package hots.instances;

import hots.In;
import hots.Objects;
import hots.Of;
import scuts.core.types.Option;
using scuts.core.extensions.Options;
import hots.classes.Monad;
import hots.classes.MonadAbstract;



using hots.box.OptionBox;

class OptionTOfMonad<M> extends MonadAbstract<Of<M, Option<In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>, app) {
    super(app);
    this.base = base;
    
  }
  
  override public function flatMap<A,B>(val:OptionTOf<M,A>, f: A->OptionTOf<M,B>):OptionTOf<M, B> 
  {
    return base.flatMap(val.unboxT(), function (a)
    {
      return switch (a) 
      {
        case Some(v): f(v).unboxT();
        case None: base.pure(None);
      }
    }).boxT();
  }
  
}

