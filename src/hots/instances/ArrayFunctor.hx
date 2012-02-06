package hots.instances;

import hots.classes.FunctorAbstract;
import hots.In;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;

using hots.instances.ArrayBox;

class ArrayFunctor
{

  static var instance:ArrayFunctorImpl;
  
  public static function get ()
  {
    if (instance == null) instance = new ArrayFunctorImpl();
    return instance;
  }
}

private class ArrayFunctorImpl extends FunctorAbstract<Array<In>>
{
  public function new () {}
  
  override public function map<B,C>(f:B->C, fa:ArrayOf<B>):ArrayOf<C> {
    return ArrayExt.map(fa.unbox(), f).box();
  }
}