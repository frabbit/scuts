package hots.instances;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import scuts.core.types.Tup2;

using hots.box.Tup2Box;

class Tup2LeftFunctor<R> extends FunctorAbstract<Tup2<In, R>>
{

  public function new() {}
  
  override public function map <L, L1> (v:Tup2LeftOf<L, R>, f:L->L1):Tup2LeftOf<L1, R>
  {
    return Tup2.create(f(v.unboxLeft()._1), v.unboxLeft()._2).boxLeft();
  }
  
}
