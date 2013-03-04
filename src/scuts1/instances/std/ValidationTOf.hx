package scuts1.instances.std;

import scuts1.core.Of;
import scuts1.core.In;
import scuts1.core.OfOf;
import scuts.core.Validations;

private typedef FP<F,S> = FailProjection<F,S>;

private typedef Val<F,S> = Validation<F,S>;

abstract ValidationTOf<M,F,S>(OfOf<M, Val<F,In>, S>) to OfOf<M, Val<F,In>, S> from OfOf<M, Val<F,In>, S>  
{ 

	public inline function new (x:OfOf<M, Val<F,In>, S>) this = x;

	@:to inline public function runT<M,F,S>():Of<M, Val<F,S>> return new Of(cast this);

	@:from public inline static function intoT<M,F,S>(x:Of<M, Val<F,S>>):ValidationTOf<M,F,S> return new ValidationTOf(cast x);
}
