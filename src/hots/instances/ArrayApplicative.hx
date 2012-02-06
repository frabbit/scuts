package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.classes.Applicative;
import scuts.core.types.Option;

using hots.instances.ArrayBox;

class ArrayApplicative
{
  static var instance:ArrayApplicativeImpl;
  
  public static function get ()
  {
    if (instance == null) instance = new ArrayApplicativeImpl();
    return instance;
  }
}

class ArrayApplicativeImpl extends ApplicativeAbstract<Array<In>>
{
  public function new () super(ArrayFunctor.get())
  
  override public function ret<B>(b:B):ArrayOf<B> 
  {
    return [b].box();
  }
  
  override public function apply<B,C>(fa:ArrayOf<B->C>, f:ArrayOf<B>):ArrayOf<C> 
  {
    var funcs = fa.unbox();
    var elems = f.unbox();
    var res = [];

    for (func in funcs) {
      for (e in elems) {
        res.push(func(e));
      }
    }
    return res.box();
  }
}