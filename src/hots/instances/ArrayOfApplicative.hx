package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.classes.Applicative;
import scuts.core.types.Option;

using hots.instances.ArrayBox;

class ArrayOfApplicativeImpl extends ApplicativeAbstract<Array<In>>
{
  public function new () super(ArrayOfFunctor.get())
  
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

typedef ArrayOfApplicative = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayOfApplicativeImpl)]>;