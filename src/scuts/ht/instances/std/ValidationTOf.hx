package scuts.ht.instances.std;

import scuts.ht.core.Of;
import scuts.ht.core.In;
import scuts.ht.core.OfOf;
import scuts.core.Validations;

import scuts.ht.core.Hots;

private typedef FP<F,S> = FailProjection<F,S>;

typedef Val<F,S> = Validation<F,S>;

//scuts.ht.instances.std.ValidationTOf<scuts.ht.core.Of<scuts.core.Io<scuts.ht.core.In>, scuts.core.Promise<scuts.ht.core.In>>, Unknown<0>, String>
abstract ValidationTOf<M,F,S>(OfOf<M, Validation<F,In>, S>) to OfOf<M, Validation<F,In>, S> from OfOf<M, Validation<F,In>, S>  
{ 

	public inline function new (x:OfOf<M, Validation<F,In>, S>) this = x;

	@:to inline public function runT<M,F,S>():Of<M, Validation<F,S>> return Hots.preservedCheckType(var _ : Of<M, Validation<F,S>> = new Of(cast this));

	@:from public inline static function intoT<M,F,S>(x:Of<M, Validation<F,S>>):ValidationTOf<M,F,S> return Hots.preservedCheckType(var _ : ValidationTOf<M,F,S> = new ValidationTOf(cast x));
}
