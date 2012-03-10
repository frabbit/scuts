package hots.instances;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import scuts.core.types.Tup2;

using hots.instances.Tup2LeftBox;

class Tup2LeftFunctorImpl<R> extends FunctorAbstract<Tup2<In, R>>
{

  public function new() {}
  
  override public function map <L, L1> (f:L->L1, v:Tup2LeftOf<L, R>):Tup2LeftOf<L1, R>
  {
    return Tup2.create(f(v.unbox()._1), v.unbox()._2).box();
  }
  
}

typedef Tup2LeftFunctor = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(Tup2LeftFunctorImpl)]>;