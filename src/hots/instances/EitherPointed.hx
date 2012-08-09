package hots.instances;


import hots.classes.PointedAbstract;
import hots.In;
import scuts.core.types.Either;

using hots.box.EitherBox;


class EitherPointed<L> extends PointedAbstract<Either<L,In>> {
  
  public function new (func) 
  {
    super(func);
  }
  
  override public function pure<A>(x:A):EitherOf<L,A> return Right(x).box()

}
