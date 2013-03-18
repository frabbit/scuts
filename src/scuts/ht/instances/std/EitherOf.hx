package scuts.ht.instances.std;
import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.core.Eithers;




abstract EitherOf<L, R>(Of<Either<L,In>, R>) 
{ 

	public inline function new (x:Either<L,R>) this = x;

	@:to public function toRP ():Either<L, R> return this;

	@:from public static function fromEither (x:Either<L,R>) return new EitherOf(cast x);

	@:to public function toEither ():Either<L, R> return cast this;

	

	@:to static inline function toOf <L,R>(x:Of<Either<L,In>, R>):Of<Either<L, In>, R> return x;

	@:from static inline function fromOf (x:Of<Either<L,In>, R>) return new EitherOf(x);
}

private typedef LP<L,R> = LeftProjection<L,R>

abstract LeftProjectionOf<L, R>(LP<L,R>) 
{ 

	public function new (x:LP<L,R>) this = x;

	@:to public function toLP ():LP<L, R> return this;

	@:from public static function fromLP (x:LP<L,R>) return new LeftProjectionOf(x);

	@:to public function toEither ():Either<L, R> return this;

	@:to static function toOf <L,R>(x:LP<L,R>):Of<LP<L, In>, R> return cast x;

	@:from static function fromOf (x:Of<LP<L,In>, R>) return cast x;
}
