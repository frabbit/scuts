package hots.instances;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import scuts.core.types.Tup2;

using hots.box.Tup2Box;

class Tup2_1Functor<B> extends FunctorAbstract<Tup2<In, B>>
{

  public function new() {}
  
  override public function map <A, AA> (v:Tup2_1Of<A, B>, f:A->AA):Tup2_1Of<AA, B>
  {
    return Tup2.create(f(v.unbox()._1), v.unbox()._2).box1();
  }
  
}
