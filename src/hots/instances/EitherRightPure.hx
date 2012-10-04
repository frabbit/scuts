package hots.instances;



import hots.classes.PureAbstract;
import hots.In;
import hots.of.EitherOf;
import scuts.core.types.Either;

using scuts.core.extensions.Eithers;

using hots.box.EitherBox;


class EitherRightPure<L> extends PureAbstract<RightProjection<L,In>> 
{
  public function new () {}
  
  override public function pure<A>(x:A):RightProjectionOf<L,A> 
  {
    return Right(x);
  }
}
