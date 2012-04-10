package hots.instances;
import hots.In;
import hots.Of;
import scuts.core.types.Either;


typedef EitherOf<L, R> = Of<Either<L, In>, R>

typedef RightProjectionOf<L, R> = Of<RightProjection<L, In>, R>

typedef LeftProjectionOf<L, R> = Of<LeftProjection<L, In>, R>
