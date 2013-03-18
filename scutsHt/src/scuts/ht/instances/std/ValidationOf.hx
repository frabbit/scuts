package scuts.ht.instances.std;
import scuts.ht.core.In;

import scuts.ht.core.Of;
import scuts.core.Validations;


private typedef FP<F,S> = FailProjection<F,S>;

private typedef Val<F,S> = Validation<F,S>;

abstract ValidationOf<F,S>(Val<F,S>) to Val<F,S> from Val<F,S> 
{

	public function new (x:Val<F,S>) this = x;

	@:from static function fromOf <F, S> (x:Of<Val<F,In>, S>):ValidationOf<F,S> return new ValidationOf(cast x);

	@:to static function toOf <F,S>(x:Val<F,S>):Of<Val<F,In>, S> return new Of(x);

}

abstract FailProjectionOf<F,S>(FP<F,S>) to FP<F,S> from FP<F,S> {

	public function new (x) this = x;

	@:from static function fromOf <F, S>(x:Of<FP<In, S>, F>):FailProjectionOf<F,S> return new FailProjectionOf(cast x);



	@:to function toOf ():Of<FP<In, S>, F> return new Of(this);

}




