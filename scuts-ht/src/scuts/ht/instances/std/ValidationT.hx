package scuts.ht.instances.std;


import scuts.core.Validations;

import scuts.ht.core.Ht;

private typedef FP<F,S> = FailProjection<F,S>;

typedef Val<F,S> = Validation<F,S>;

abstract ValidationT<M,F,S>(M<Validation<F,S>>)
{

	inline function new (x:M<Validation<F,S>>) this = x;

	inline function unwrap ():M<Validation<F,S>> return this;

	public inline static function runT<M,F,S>(x:ValidationT<M,F,S>) return x.unwrap();

	public inline static function validationT<M,F,S>(x:M<Validation<F,S>>) return new ValidationT(x);
}
