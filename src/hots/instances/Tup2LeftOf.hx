package hots.instances;
import hots.In;
import hots.Of;
import scuts.core.types.Tup2;

typedef Tup2LeftOf<L,R> = Of<Tup2<In, R>, L>;
