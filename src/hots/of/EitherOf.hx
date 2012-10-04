package hots.of;
import hots.In;
import hots.Of;
import scuts.core.types.Either;


abstract RightProjectionOf<L, R> => RightProjection<L,R>, <= RightProjection<L,R>, => Of<RightProjection<L, In>, R>, <= Of<RightProjection<L, In>, R> { }

abstract LeftProjectionOf<L, R> => LeftProjection<L,R>, <= LeftProjection<L,R>, => Of<LeftProjection<In, R>, L>, <= Of<LeftProjection<In, R>, L> { }
