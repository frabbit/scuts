package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import scuts.core.extensions.OptionExt;

import hots.classes.Applicative;
import hots.classes.Functor;
import scuts.core.types.Option;

using hots.instances.OptionBox;

class OptionFunctor
{
  static var instance;
  
  public static function get ()
  {
    if (instance == null) instance = new OptionFunctorImpl();
    return instance;
  }
}

private class OptionFunctorImpl extends FunctorAbstract<Option<In>>
{
  public function new () {}
  
  override public function map<A,B>(f:A->B, val:OptionOf<A>):OptionOf<B> {
    return OptionExt.map(val.unbox(), f).box();
  }
}