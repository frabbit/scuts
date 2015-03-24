package scuts.ht.instances.std;
import scuts.ht.core._;
import scuts.ht.core.Of;
import scuts.core.Eithers;


private typedef LP<L,R> = LeftProjection<L,R>

abstract LeftProjectionOf<L, R>(LP<L,R>)
{
	public function new (x:LP<L,R>) this = x;

	@:to public function toLP ():LP<L, R> return this;

	@:from public static function fromLP (x:LP<L,R>) return new LeftProjectionOf(x);

	@:to public function toEither ():Either<L, R> return this;

}
