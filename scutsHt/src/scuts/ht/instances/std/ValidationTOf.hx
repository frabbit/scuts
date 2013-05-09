package scuts.ht.instances.std;

import scuts.ht.core.Of;
import scuts.ht.core.In;
import scuts.ht.core.OfOf;
import scuts.core.Validations;

import scuts.ht.core.Ht;

private typedef FP<F,S> = FailProjection<F,S>;

typedef Val<F,S> = Validation<F,S>;

class ValidationTOfHelper {
	@:noUsing public static function intoT <M,F,S>(x:Of<M, Validation<F,S>>):ValidationTOf<M,F,S>	{
		return new ValidationTOf(cast x);
	}
}

abstract ValidationTOf<M,F,S>(OfOf<M, Validation<F,In>, S>) to OfOf<M, Validation<F,In>, S> from OfOf<M, Validation<F,In>, S>  
{ 
	@:allow(scuts.ht.instances.std.ValidationTOfHelper)
	inline function new (x:OfOf<M, Validation<F,In>, S>) this = x;

	@:to inline public function runT<M,F,S>():Of<M, Validation<F,S>> return Ht.preservedCheckType(var _ : Of<M, Validation<F,S>> = new Of(cast this));

	@:from public inline static function intoT<M,F,S>(x:Of<M, Validation<F,S>>):ValidationTOf<M,F,S> return ValidationTOfHelper.intoT(x);
}
