package hots.instances;

import hots.classes.ApplicativeAbstract;
import hots.In;
import hots.classes.Applicative;
import scuts.core.types.Option;

using hots.instances.ArrayBox;

class ArrayOfApplicative extends ApplicativeAbstract<Array<In>>
{
  public function new () super(ArrayOfPointed.get())
  
  override public function apply<B,C>(f:ArrayOf<B->C>, v:ArrayOf<B>):ArrayOf<C> 
  {
    var res = [];
    for (func in f.unbox()) {
      for (e in v.unbox()) {
        res.push(func(e));
      }
    }
    return res.box();
  }
}

//typedef ArrayOfApplicative = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayOfApplicativeImpl)]>;