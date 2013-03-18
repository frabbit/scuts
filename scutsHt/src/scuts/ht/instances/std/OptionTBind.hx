package scuts.ht.instances.std;

import scuts.ht.classes.Bind;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.instances.std.OptionTOf;


import scuts.ht.classes.Monad;
import scuts.core.Options.Option;



class OptionTBind<M> implements Bind<Of<M, Option<In>>> {
  
  var base:Monad<M>;
  
  public function new (base:Monad<M>) 
  {
    this.base = base;
  }
  
  // public function flatMap<A,B>(x:Of<M,A>, f:A->Of<M,B>):Of<M,B>;
  public function flatMap<A,B>(x:OptionTOf<M,A>, f: A->OptionTOf<M,B>):OptionTOf<M, B> 
  {
    
    function f1 (a) return switch (a) 
    {
      case Some(v): f(v);
      case None: base.pure(None);
    }
    return base.flatMap(x, f1);
    
  }
}
