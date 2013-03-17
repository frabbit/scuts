package scuts.ht.instances.std;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.core.Either;


private typedef RP<L,R> = RightProjection<L,R>
private typedef LP<L,R> = LeftProjection<L,R>

abstract RightProjectionOf<L, R>(RP<L,R>) 
{ 

	public inline function new (x:RP<L,R>) this = x;

	@:to public function toRP ():RP<L, R> return this;

	@:from public static function fromRP (x:RP<L,R>) return new RightProjectionOf(x);

	@:to public function toEither ():Either<L, R> return this;

	

	@:to static inline function toOf <L,R>(x:RP<L,R>):Of<RP<L, In>, R> return new Of(x);

	@:from static inline function fromOf (x:Of<RP<L,In>, R>) return new RightProjectionOf(cast x);
}

abstract LeftProjectionOf<L, R>(LP<L,R>) 
{ 

	public function new (x:LP<L,R>) this = x;

	@:to public function toLP ():LP<L, R> return this;

	@:from public static function fromLP (x:LP<L,R>) return new LeftProjectionOf(x);

	@:to public function toEither ():Either<L, R> return this;

	@:to static function toOf <L,R>(x:LP<L,R>):Of<LP<L, In>, R> return cast x;

	@:from static function fromOf (x:Of<LP<L,In>, R>) return cast x;
}
