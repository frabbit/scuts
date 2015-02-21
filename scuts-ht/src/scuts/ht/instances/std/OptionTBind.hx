package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
using scuts.ht.instances.std.OptionT;


import scuts.ht.classes.Monad;
import scuts.core.Options.Option;



class OptionTBind<M> implements Bind<OptionT<M,_>> {

  var base:Monad<M>;

  public function new (base:Monad<M>)
  {
    this.base = base;
  }

  public function flatMap<A,B>(x:OptionT<M,A>, f: A->OptionT<M,B>):OptionT<M, B>
  {
    function f1 (a):M<Option<B>> return switch (a)
    {
      case Some(v): f(v).runT();
      case None: base.pure(None);
    }
    return base.flatMap(x.runT(), f1).optionT();

  }
}
